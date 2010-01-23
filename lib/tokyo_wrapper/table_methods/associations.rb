module TokyoWrapper

  module TableMethods
  
    module Associations

      def add_has_many_association_id(id, association_id_name, association_id)
        if !@table[id.to_s].nil? && !@table[id.to_s].empty?
          association_ids_string = @table[id.to_s]["#{association_id_name}s"]
          if association_ids_string.nil?
            @table[id.to_s] = @table[id.to_s].merge({"#{association_id_name}s" => association_id.to_s})
          elsif !association_ids_string.split(",").include?(association_id.to_s)
            @table[id.to_s] = @table[id.to_s].merge({"#{association_id_name}s" => "#{association_ids_string},#{association_id}"})
          end
          true
        else
          false
        end      
      end      
      
    end
  
  end

end