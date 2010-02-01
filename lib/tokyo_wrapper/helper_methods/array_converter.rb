module TokyoWrapper

  module HelperMethods
  
    module ArrayConverter

      # 
      # rufus-tokyo converts array to string without a delimiter e.g. It converts [1,2,3,4] to "1234". 
      # So the array needs to be converted to the comma separated string before being added. e.g. "1,2,3,4"
      #
      def convert_params(params)
        params.each do |key, value|
          if value.instance_of?(Array)
            params[key] = value.join(",")
          end
        end
        params
      end
      
      def convert_comman_separated_values_string_to_array(comman_separated_values_string)
        comman_separated_values_string.split(',').compact
      end
      
      def convert_values_to_array_for_keys(key_value_hash, keys)
        if !keys.nil? && !keys.empty?
          keys.each do |key|
            if key_value_hash.has_key?(key)
              key_value_hash[key] = convert_comman_separated_values_string_to_array(key_value_hash[key])
            end
          end
        end
        key_value_hash
      end

      def convert_values_to_array_for_keys_for_multiple_key_value_hashes(key_value_hashes, keys)
        key_value_hashes.each do |key_value_hash|
          convert_values_to_array_for_keys(key_value_hash, keys)
        end
        key_value_hashes
      end
      
    end
    
  end

end