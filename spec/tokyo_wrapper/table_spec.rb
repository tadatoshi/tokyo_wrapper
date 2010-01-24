require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TokyoWrapper::Table do
  include RufusTokyoMacros
  
  before(:each) do
    @table_file = File.expand_path(File.dirname(__FILE__) + '/../tokyo_cabinet_files/table.tct')
    clear_table(@table_file)
  end

  after(:each) do
    clear_table(@table_file)
  end
  
  context "Add" do
    
    it "should add data" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)

        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes"}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)

        read_table.all.should == [{:pk => id.to_s,
                                   "street" => "1111 Main", 
                                   "city" => "Montreal", 
                                   "notes" => "Some notes"}]
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes"} 
      ensure      
        read_table.close unless read_table.nil?
      end           
      
    end
    
  end
  
  context "Update" do
    
    it "should update data" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes"}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)      
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes"}   
      ensure
        read_table.close unless read_table.nil?
      end
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
                                                         
        result = write_table.update(id, "notes" => "Recently situation has been changed.")
        result.should be_true
      ensure
        write_table.close unless write_table.nil?
      end

      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)  
      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Recently situation has been changed."}
      ensure
        read_table.close unless read_table.nil?
      end                                   
      
    end
    
  end
  
  context "Delete" do
    
    it "should delete a row" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes"}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)      
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes"}   
      ensure
        read_table.close unless read_table.nil?
      end
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
                                                         
        write_table.delete(id)
      ensure
        write_table.close unless write_table.nil?
      end

      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)  
      
        read_table.find(id).should be_nil
      ensure
        read_table.close unless read_table.nil?
      end         
      
    end
    
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
    
  end
  
end