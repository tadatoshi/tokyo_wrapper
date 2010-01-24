require 'tokyo_wrapper/table_methods/associations'

module TokyoWrapper

  class Table
    include TokyoWrapper::TableMethods::Associations
    
    def initialize(table)
      @table = table
    end
  
    def self.create_with_create_write_non_blocking_lock(file)
      table = Rufus::Tokyo::Table.new(File.expand_path(file), :mode => "cwf")
      self.new(table)
    end  
  
    def self.create_with_write_non_blocking_lock(file)
      table = Rufus::Tokyo::Table.new(File.expand_path(file), :mode => "wf")
      self.new(table)
    end
  
    def self.create_with_read_non_locking(file)
      table = Rufus::Tokyo::Table.new(File.expand_path(file), :mode => "re")
      self.new(table)
    end

    def close
      @table.close
    end  
  
    def add(params = {})
      id = @table.generate_unique_id
      @table[id] = convert_params(params)
      id
    end
  
    def update(id, params)
      if !@table[id.to_s].nil? && !@table[id.to_s].empty?
        @table[id.to_s] = @table[id.to_s].merge(convert_params(params))
        true
      else
        false
      end
    end   
    
    def delete(id)
      @table.delete(id.to_s)
    end     
  
    def all
      @table.query
    end  
  
    def find(id)
      @table[id.to_s]
    end
    
    private
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
      end
    
  end

end