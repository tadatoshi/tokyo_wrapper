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
  
  context "store file content" do
    
    it "should store the content of the specified text file" do
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        temp_file_content = open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/temp.txt')).read

        data_hash = {"filename" => "temp.txt", 
                     "content_type" => "text/plain", 
                     "size" => File.size(File.expand_path(File.dirname(__FILE__) + '/../fixtures/temp.txt')),
                     "file_data" => temp_file_content}
        id = write_table.add(data_hash)   

      ensure
        write_table.close unless write_table.nil?
      end            
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)

        read_table.find(id)["filename"].should == "temp.txt"   
        read_table.find(id)["content_type"].should == "text/plain"   
        read_table.find(id)["size"].should == "79"                           
        read_table.find(id)["file_data"].should == "This is for testing storing the content of the file. \nDon't modify the content."
      ensure
        read_table.close unless read_table.nil?
      end   
      
    end
      
    it "should store the content of the specified image file" do      
      
      begin
        write_table = TokyoWrapper::Table.create_with_create_write_non_blocking_lock(@table_file)
      
        image_file_content = open(File.expand_path(File.dirname(__FILE__) + '/../fixtures/rails.png')).read

        data_hash = {"filename" => "rails.png", 
                     "content_type" => "image/png", 
                     "size" => File.size(File.expand_path(File.dirname(__FILE__) + '/../fixtures/rails.png')),
                     "file_data" => image_file_content}
        id = write_table.add(data_hash)   

      ensure
        write_table.close unless write_table.nil?
      end            
      
      begin
        read_table = TokyoWrapper::Table.create_with_read_non_locking(@table_file)
        
        read_table.find(id)["filename"].should == "rails.png"   
        read_table.find(id)["content_type"].should == "image/png"   
        read_table.find(id)["size"].should == "1787"
                                     
        file_for_retrieved_content = File.new(File.expand_path(File.dirname(__FILE__) + '/../fixtures/retrieved_rails.png'), "w")
        file_for_retrieved_content.write(read_table.find(id)["file_data"])
        file_for_retrieved_content.close
        File.exists?(File.expand_path(File.dirname(__FILE__) + '/../fixtures/retrieved_rails.png')).should be_true
        File.size(File.expand_path(File.dirname(__FILE__) + '/../fixtures/retrieved_rails.png')).should == File.size(File.expand_path(File.dirname(__FILE__) + '/../fixtures/rails.png'))

      ensure
        File.delete(File.expand_path(File.dirname(__FILE__) + '/../fixtures/retrieved_rails.png')) if File.exists?(File.expand_path(File.dirname(__FILE__) + '/../fixtures/retrieved_rails.png'))
        read_table.close unless read_table.nil?
      end                   
      
    end
    
  end
  
end