module TokyoWrapper

  module TableMethods
  
    module Query
      
      def all_by_key_values(key_value_hash = {})
        @table.query do |query|
          key_value_hash.each do |key, value|
            query.add key, :equals, value
          end
        end
      end

    end
  
  end

end