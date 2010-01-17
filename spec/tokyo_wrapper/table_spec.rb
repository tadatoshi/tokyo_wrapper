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
  
end