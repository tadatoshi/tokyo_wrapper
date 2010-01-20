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
    
    before(:each) do
      @table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
    end
    
    after(:each) do
      @table.close  
    end
    
    it "should add data" do

      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes"}
      id = @table.add(data_hash)

      @table.all.should == [{:pk => id.to_s,
                             "street" => "1111 Main", 
                             "city" => "Montreal", 
                             "notes" => "Some notes"}]
                                      
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes"}                        
      
    end
    
  end
  
  context "Update" do
    
    before(:each) do
      @table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
    end
    
    after(:each) do
      @table.close  
    end    
    
    it "should update data" do   
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes"}
      id = @table.add(data_hash)
                                      
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes"}    
                                          
      result = @table.update(id, "notes" => "Recently situation has been changed.")
      
      result.should be_true
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Recently situation has been changed."}        
      
    end
    
  end
  
  context "One-to-many and many-to-many associations" do
    
    before(:each) do
      @table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
    end
    
    after(:each) do
      @table.close  
    end        
    
    it "should convert array parameter value to joined comma-separated string" do
      
      params_1 = { "name" => "Temp name", "sector_ids" => [2,5,34,8] }
      
      @table.send(:convert_params, params_1).should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }
      
      params_2 = { "name" => "Temp name", "sector_ids" => ["2","5","34","8"] }
      
      @table.send(:convert_params, params_2).should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }      
      
    end
    
    it "should add data with association" do
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = @table.add(data_hash)

      @table.all.should == [{:pk => id.to_s,
                             "street" => "1111 Main", 
                             "city" => "Montreal", 
                             "notes" => "Some notes", 
                             "sector_ids" => "2,5,34,8"}]
                                      
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8"}

    end
    
    it "should update data with association" do   
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = @table.add(data_hash)
                                      
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8"}    
                                          
      result = @table.update(id, "notes" => "Recently situation has been changed.", "sector_ids" => ["2","5","40","8","12"])
      
      result.should be_true
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Recently situation has been changed.", 
                                 "sector_ids" => "2,5,40,8,12"}        
      
    end
    
    it "should add an association id" do
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = @table.add(data_hash)
                                      
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8"}   
                                 
      result_1 = @table.add_association_id(id, "sector_id", 78)
      
      result_1.should be_true
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8,78"}   
                                 
      result_2 = @table.add_association_id(id, "sector_id", "3")
      
      result_2.should be_true
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8,78,3"}                                             
      
    end
    
    it "should not add an association id if it's already set" do
      
      data_hash = {"street" => "1111 Main", 
                   "city" => "Montreal", 
                   "notes" => "Some notes", 
                   "sector_ids" => ["2","5","34","8"]}
      id = @table.add(data_hash)
                                      
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8"}   
                                 
      result_1 = @table.add_association_id(id, "sector_id", "8")
      result_1.should be_true
      @table.find(id).should == {"street" => "1111 Main", 
                                 "city" => "Montreal", 
                                 "notes" => "Some notes", 
                                 "sector_ids" => "2,5,34,8"}                                            
      
    end
    
  end
  
end