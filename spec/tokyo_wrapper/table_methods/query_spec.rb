require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe TokyoWrapper::TableMethods::Query do
  include RufusTokyoMacros
  
  before(:each) do
    @table_file = File.expand_path(File.dirname(__FILE__) + '/../../tokyo_cabinet_files/table.tct')
    clear_table(@table_file)
  end

  after(:each) do
    clear_table(@table_file)
  end
  
  context "Find all" do
    
    it "should find all the rows that have a given value" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash_1 = {"street" => "1111 Main", 
                       "city" => "Montreal", 
                       "province" => "Quebec",
                       "country" => "Canada",
                       "notes" => "Some notes"}
        id_1 = write_table.add(data_hash_1)
        data_hash_2 = {"street" => "1111 Maisonneuve",
                       "city" => "Montreal", 
                       "province" => "Quebec", 
                       "country" => "Canada",
                       "notes" => "Another notes"}
        id_2 = write_table.add(data_hash_2)
        data_hash_3 = {"street" => "1111 Main", 
                       "city" => "Quebec", 
                       "province" => "Quebec",
                       "country" => "Canada", 
                       "notes" => "Different notes"}
        id_3 = write_table.add(data_hash_3)        
        
      ensure
        write_table.close unless write_table.nil?
      end      

      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)      
                                      
        read_table.all_by_key_value("city", "Montreal").should == [{:pk => id_1.to_s, 
                                                                    "street" => "1111 Main", 
                                                                    "city" => "Montreal", 
                                                                    "province" => "Quebec",
                                                                    "country" => "Canada",
                                                                    "notes" => "Some notes"}, 
                                                                   {:pk => id_2.to_s, 
                                                                    "street" => "1111 Maisonneuve",
                                                                    "city" => "Montreal", 
                                                                    "province" => "Quebec", 
                                                                    "country" => "Canada",
                                                                    "notes" => "Another notes"}]
      ensure
        read_table.close unless read_table.nil?
      end      
      
    end
    
    it "should find all the rows that have a given value with has_many association ids converted to array" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash_1 = {"street" => "1111 Main", 
                       "city" => "Montreal", 
                       "province" => "Quebec",
                       "country" => "Canada",
                       "notes" => "Some notes", 
                       "sector_ids" => "2,5,34,8"}
        id_1 = write_table.add(data_hash_1)
        data_hash_2 = {"street" => "1111 Maisonneuve",
                       "city" => "Montreal", 
                       "province" => "Quebec", 
                       "country" => "Canada",
                       "notes" => "Another notes",
                       "sector_ids" => "3,5,6,8"}
        id_2 = write_table.add(data_hash_2)
        data_hash_3 = {"street" => "1111 Main", 
                       "city" => "Quebec", 
                       "province" => "Quebec",
                       "country" => "Canada", 
                       "notes" => "Different notes",
                       "sector_ids" => "2,1,34,7"}
        id_3 = write_table.add(data_hash_3)        
        
      ensure
        write_table.close unless write_table.nil?
      end      

      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)      
                                      
        read_table.all_by_key_value("city", "Montreal", 
                                    :keys_for_has_many_association => ["sector_ids"]).should == [{:pk => id_1.to_s, 
                                                                                                  "street" => "1111 Main", 
                                                                                                  "city" => "Montreal", 
                                                                                                  "province" => "Quebec",
                                                                                                  "country" => "Canada",
                                                                                                  "notes" => "Some notes", 
                                                                                                  "sector_ids" => ["2","5","34","8"]}, 
                                                                                                 {:pk => id_2.to_s, 
                                                                                                  "street" => "1111 Maisonneuve",
                                                                                                  "city" => "Montreal", 
                                                                                                  "province" => "Quebec", 
                                                                                                  "country" => "Canada",
                                                                                                  "notes" => "Another notes", 
                                                                                                  "sector_ids" => ["3","5","6","8"]}]
      ensure
        read_table.close unless read_table.nil?
      end      
      
    end    
    
    it "should find all the rows that have given values" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash_1 = {"street" => "1111 Main", 
                       "city" => "Montreal", 
                       "province" => "Quebec",
                       "country" => "Canada",
                       "notes" => "Some notes", 
                       "register_id" => "45", 
                       "sector_ids" => ["2","5","32","8"]}
        id_1 = write_table.add(data_hash_1)
        data_hash_2 = {"street" => "1111 Maisonneuve",
                       "city" => "Montreal", 
                       "province" => "Quebec", 
                       "country" => "Canada",
                       "notes" => "Another notes", 
                       "register_id" => "8", 
                       "sector_ids" => ["1","2","3458","9"]}
        id_2 = write_table.add(data_hash_2)
        data_hash_3 = {"street" => "1111 Main", 
                       "city" => "Quebec", 
                       "province" => "Quebec",
                       "country" => "Canada", 
                       "notes" => "Different notes", 
                       "register_id" => "8", 
                       "sector_ids" => ["87","45","1","727"]}
        id_3 = write_table.add(data_hash_3)  
        data_hash_4 = {"street" => "1112 Main", 
                       "city" => "Montreal", 
                       "province" => "Quebec",
                       "country" => "Canada", 
                       "notes" => "One more note", 
                       "register_id" => "45", 
                       "sector_ids" => ["87","45","1","727"]}
        id_4 = write_table.add(data_hash_4)            
        
      ensure
        write_table.close unless write_table.nil?
      end      

      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)      
                                      
        read_table.all_by_multiple_key_values({"city" => "Montreal", 
                                               "register_id" => "45"}).should == [{:pk => id_1.to_s, 
                                                                                   "street" => "1111 Main", 
                                                                                   "city" => "Montreal", 
                                                                                   "province" => "Quebec",
                                                                                   "country" => "Canada",
                                                                                   "notes" => "Some notes", 
                                                                                   "register_id" => "45", 
                                                                                   "sector_ids" => "2,5,32,8"}, 
                                                                                  {:pk => id_4.to_s, 
                                                                                   "street" => "1112 Main", 
                                                                                   "city" => "Montreal", 
                                                                                   "province" => "Quebec",
                                                                                   "country" => "Canada", 
                                                                                   "notes" => "One more note", 
                                                                                   "register_id" => "45", 
                                                                                   "sector_ids" => "87,45,1,727"}]
                                                                                   
        read_table.all_by_multiple_key_values({"city" => "Montreal", 
                                               "register_id" => "45"}, 
                                              {:keys_for_has_many_association => ["sector_ids"]}).should == [{:pk => id_1.to_s, 
                                                                                                              "street" => "1111 Main", 
                                                                                                              "city" => "Montreal", 
                                                                                                              "province" => "Quebec",
                                                                                                              "country" => "Canada",
                                                                                                              "notes" => "Some notes", 
                                                                                                              "register_id" => "45", 
                                                                                                              "sector_ids" => ["2","5","32","8"]}, 
                                                                                                             {:pk => id_4.to_s, 
                                                                                                              "street" => "1112 Main", 
                                                                                                              "city" => "Montreal", 
                                                                                                              "province" => "Quebec",
                                                                                                              "country" => "Canada", 
                                                                                                              "notes" => "One more note", 
                                                                                                              "register_id" => "45", 
                                                                                                              "sector_ids" => ["87","45","1","727"]}]                                                                                   
      ensure
        read_table.close unless read_table.nil?
      end      
      
    end
    
  end
  
end