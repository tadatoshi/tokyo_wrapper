require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'tokyo_wrapper/helper_methods/array_converter'

describe TokyoWrapper::HelperMethods::ArrayConverter do
  
  class ArrayConverterIncluder
    include TokyoWrapper::HelperMethods::ArrayConverter
  end
  
  before(:each) do
    @array_converter_includer = ArrayConverterIncluder.new
  end

  after(:each) do
  end
  
  context "Convert between array and string" do
        
    it "should convert array to string with comma separated elements" do
      
      params_1 = { "name" => "Temp name", "sector_ids" => [2,5,34,8] }
      
      result_1 = @array_converter_includer.convert_params(params_1)
      
      result_1.should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }
      params_1.should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }
      
      params_2 = { "name" => "Temp name", "sector_ids" => ["2","5","34","8"] }
      
      result_2 = @array_converter_includer.convert_params(params_2)
      
      result_2.should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }
      params_2.should == { "name" => "Temp name", "sector_ids" => "2,5,34,8" }
      
    end
    
    it "should convert string with comma separated elements to array" do
      
      @array_converter_includer.convert_comma_separated_values_string_to_array("2,5,32,8").should == ["2","5","32","8"]
      @array_converter_includer.convert_comma_separated_values_string_to_array("2,5,,8").should == ["2","5","","8"]
      
    end
    
    it "should convert string with comma separated elements to array for the given key" do
      
      key_value_hash_1 = {"name" => "Temp name", "sector_ids" => "2,5,34,8", "some_ids" => "8,32,9"}
      keys_1 = ["sector_ids", "some_ids"]
      
      result_1 = @array_converter_includer.convert_values_to_array_for_keys(key_value_hash_1, keys_1)
      
      result_1.should == {"name" => "Temp name", "sector_ids" => ["2","5","34","8"], "some_ids" => ["8","32","9"]}
      key_value_hash_1.should == {"name" => "Temp name", "sector_ids" => ["2","5","34","8"], "some_ids" => ["8","32","9"]}

      key_value_hash_2 = {"name" => "Temp name", "sector_ids" => "2,5,34,8", "some_ids" => "8,32,9"}

      result_2 = @array_converter_includer.convert_values_to_array_for_keys(key_value_hash_2, nil)
      
      result_2.should == {"name" => "Temp name", "sector_ids" => "2,5,34,8", "some_ids" => "8,32,9"}
      key_value_hash_2.should == {"name" => "Temp name", "sector_ids" => "2,5,34,8", "some_ids" => "8,32,9"}
      
    end
    
    it "should convert string with comma separated elements to array for the given key for multiple key value hashes" do
      
      key_value_hashes_1 = [{"name" => "Temp name 1", "sector_ids" => "2,5,34,8", "some_ids" => "8,32,9"}, 
                            {"name" => "Temp name 1", "sector_ids" => "5,43,34,6"}]
      keys_1 = ["sector_ids", "some_ids"]
      
      result_1 = @array_converter_includer.convert_values_to_array_for_keys_for_multiple_key_value_hashes(key_value_hashes_1, keys_1)
      
      result_1.should == [{"name" => "Temp name 1", "sector_ids" => ["2","5","34","8"], "some_ids" => ["8","32","9"]}, 
                          {"name" => "Temp name 1", "sector_ids" => ["5","43","34","6"]}]
      key_value_hashes_1.should == [{"name" => "Temp name 1", "sector_ids" => ["2","5","34","8"], "some_ids" => ["8","32","9"]}, 
                                    {"name" => "Temp name 1", "sector_ids" => ["5","43","34","6"]}]

    end    
    
  end
  
end