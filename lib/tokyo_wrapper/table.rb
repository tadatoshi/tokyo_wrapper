require 'tokyo_wrapper/helper_methods/array_converter'
require 'tokyo_wrapper/table_methods/associations'
require 'tokyo_wrapper/table_methods/query'

module TokyoWrapper

  class Table
    include TokyoWrapper::HelperMethods::ArrayConverter
    include TokyoWrapper::TableMethods::Associations
    include TokyoWrapper::TableMethods::Query
    
    def initialize(table)
      @table = table
    end
  
    def self.create_with_create_write_non_blocking_lock(file, &block)
      create(file, "cwf", &block)
    end  
  
    def self.create_with_write_non_blocking_lock(file, &block)
      create(file, "wf", &block)
    end
  
    def self.create_with_read_non_locking(file, &block)
      create(file, "re", &block)
    end

    def self.create(file, mode, &block)
      if block_given?
        begin
          table = Rufus::Tokyo::Table.new(File.expand_path(file), :mode => mode)
          return_value_from_block = block.call(new(table))
        ensure
          table.close unless table.nil?
        end
        return_value_from_block
      else
        new(Rufus::Tokyo::Table.new(File.expand_path(file), :mode => mode))
      end
    end

    private_class_method :new, :create    

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
  
    def all(options = {})
      result = @table.query
      convert_values_to_array_for_keys_for_multiple_key_value_hashes(result, options[:keys_for_has_many_association])
    end

    def find(id, options = {})
      if !options.empty? && options[:pk_included] == true
        result = @table[id.to_s].merge({:pk => id.to_s})
      else
        result = @table[id.to_s]
      end
      convert_values_to_array_for_keys(result, options[:keys_for_has_many_association])
    end
    
  end

end