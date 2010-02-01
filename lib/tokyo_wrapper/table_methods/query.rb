module TokyoWrapper

  module TableMethods
  
    module Query
      
      def all_by_multiple_key_values(key_value_hash = {}, options = {})
        result = @table.query do |query|
          key_value_hash.each do |key, value|
            query.add key, :equals, value
          end
        end
        convert_values_to_array_for_keys_for_multiple_key_value_hashes(result, options[:keys_for_has_many_association])
      end

    end
  
  end

end