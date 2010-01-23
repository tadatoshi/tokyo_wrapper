require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe TokyoWrapper::TableMethods::Associations do
  include RufusTokyoMacros
  
  before(:each) do
    @table_file = File.expand_path(File.dirname(__FILE__) + '/../../tokyo_cabinet_files/table.tct')
    clear_table(@table_file)
  end

  after(:each) do
    clear_table(@table_file)
  end
  
  context "One-to-many and many-to-many associations" do 
    
    it "should convert array parameter value to joined comma-separated string" do
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
      
      params_1 = { "name" => "Temp name", "sector_ids" => [2,5,34,8] }
      
      write_table.send(:convert_params, params_1).should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }
      
      params_2 = { "name" => "Temp name", "sector_ids" => ["2","5","34","8"] }
      
      write_table.send(:convert_params, params_2).should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }   
      
      write_table.close   
      
    end
    
    it "should add data with has_many association" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes", 
                     "sector_ids" => ["2","5","34","8"]}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)

        read_table.all.should == [{:pk => id.to_s,
                                   "street" => "1111 Main", 
                                   "city" => "Montreal", 
                                   "notes" => "Some notes", 
                                   "sector_ids" => "2,5,34,8"}]
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8"}
      ensure                           
        read_table.close unless read_table.nil?
      end                           

    end
    
    it "should update data with has_many association" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes", 
                     "sector_ids" => ["2","5","34","8"]}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8"}  
      ensure                           
        read_table.close unless read_table.nil?
      end                           
                                 
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                             
                                          
        result = write_table.update(id, "notes" => "Recently situation has been changed.", "sector_ids" => ["2","5","40","8","12"])
        result.should be_true
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Recently situation has been changed.", 
                                       "sector_ids" => "2,5,40,8,12"}  
      ensure      
        read_table.close unless read_table.nil?
      end                                   
      
    end
    
    it "should add a has_many association id" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes", 
                     "sector_ids" => ["2","5","34","8"]}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8"}  
      ensure                      
        read_table.close unless read_table.nil?
      end                           
        
      begin                           
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                            
                                 
        result_1 = write_table.add_has_many_association_id(id, "sector_id", 78)
        result_1.should be_true
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8,78"}  
      ensure        
        read_table.close unless read_table.nil?
      end
                                 
      begin                           
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                            
                                 
        result_2 = write_table.add_has_many_association_id(id, "sector_id", "3")
        result_2.should be_true
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8,78,3"} 
      ensure          
        read_table.close unless read_table.nil?
      end                                                                       
      
    end
    
    it "should not add a has_many association id if it's already set" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes", 
                     "sector_ids" => ["2","5","34","8"]}
        id = write_table.add(data_hash)
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
                                      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8"} 
      ensure       
        read_table.close unless read_table.nil?
      end                           
                                 
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                             
                                 
        result_1 = write_table.add_has_many_association_id(id, "sector_id", "8")
        result_1.should be_true
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "2,5,34,8"}  
      ensure          
        read_table.close unless read_table.nil?
      end                                                                     
      
    end
    
    it "should add a has_many association id when no association id is set for the association" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        data_hash = {"street" => "1111 Main", 
                     "city" => "Montreal", 
                     "notes" => "Some notes"}
        id = write_table.add(data_hash)
      
        result_1 = write_table.add_has_many_association_id(id, "sector_id", "8")
        result_1.should be_true      
      ensure
        write_table.close unless write_table.nil?
      end
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
        read_table.find(id).should == {"street" => "1111 Main", 
                                       "city" => "Montreal", 
                                       "notes" => "Some notes", 
                                       "sector_ids" => "8"}  
      ensure
        read_table.close unless read_table.nil?
      end      
      
    end
    
  end
  
end