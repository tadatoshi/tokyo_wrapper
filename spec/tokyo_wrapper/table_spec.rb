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
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)

      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes"}
      id = write_table.add(data_hash)
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)

      read_table.all.should == [{:pk => id.to_s,
                                 "street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes"}]
                                      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes"} 
                                 
      read_table.close                      
      
    end
    
  end
  
  context "Update" do
    
    it "should update data" do
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes"}
      id = write_table.add(data_hash)
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)      
                                      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes"}   
                                 
      read_table.close
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
                                                         
      result = write_table.update(id, "notes" => "Recently situation has been changed.")
      result.should be_true
      
      write_table.close

      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)  
      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Recently situation has been changed."}
                                 
      read_table.close                                   
      
    end
    
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
    
    it "should add data with association" do
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file) 
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = write_table.add(data_hash)
      
      write_table.close
      
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
                                 
      read_table.close                           

    end
    
    it "should update data with association" do
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = write_table.add(data_hash)
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
                                      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes", 
                                     "sector_ids" => "2,5,34,8"}  
                                 
      read_table.close                             
                                 
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                             
                                          
      result = write_table.update(id, "notes" => "Recently situation has been changed.", "sector_ids" => ["2","5","40","8","12"])
      result.should be_true
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Recently situation has been changed.", 
                                     "sector_ids" => "2,5,40,8,12"}  
                              
      read_table.close                                   
      
    end
    
    it "should add an association id" do
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = write_table.add(data_hash)
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
                                      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes", 
                                     "sector_ids" => "2,5,34,8"}  
                                 
      read_table.close                           
                                 
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                            
                                 
      result_1 = write_table.add_association_id(id, "sector_id", 78)
      result_1.should be_true
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes", 
                                     "sector_ids" => "2,5,34,8,78"}  
                                 
      read_table.close                           
                                 
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                            
                                 
      result_2 = write_table.add_association_id(id, "sector_id", "3")
      result_2.should be_true
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes", 
                                     "sector_ids" => "2,5,34,8,78,3"} 
                                 
      read_table.close                                                                       
      
    end
    
    it "should not add an association id if it's already set" do
      
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = write_table.add(data_hash)
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
                                      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes", 
                                     "sector_ids" => "2,5,34,8"} 
                                 
      read_table.close                           
                                 
      write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)                             
                                 
      result_1 = write_table.add_association_id(id, "sector_id", "8")
      result_1.should be_true
      
      write_table.close
      
      read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
      
      read_table.find(id).should == {"street" => "1111 Main", 
                                     "city" => "Montreal", 
                                     "notes" => "Some notes", 
                                     "sector_ids" => "2,5,34,8"}  
                                 
      read_table.close                                                                     
      
    end
    
  end
  
end