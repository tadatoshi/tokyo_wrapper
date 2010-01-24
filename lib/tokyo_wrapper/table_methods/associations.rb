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
      
      def all_by_has_many_association_id(association_id_name, association_id)
        @table.query do | query | 
          query.add "#{association_id_name}s", :stror, association_id.to_s
        end
      end
      
      def set_belongs_to_association_id(id, association_id_name, association_id)
        if !@table[id.to_s].nil? && !@table[id.to_s].empty?
          @table[id.to_s] = @table[id.to_s].merge({association_id_name => association_id.to_s})
          true
        else
          false
        end
      end   
      
      def keys_for_belongs_to_association_id(association_id_name, association_id)
        table_result_set = @table.query do |query|
          query.add association_id_name, :equals, association_id.to_s
          query.no_pk
        end
        keys = []
        table_result_set.each do |row|
          keys += row.keys
          keys.uniq!
        end
        keys.delete(association_id_name)
        keys.sort
      end
      
    end
  
  end

end