module TokyoWrapper

  class Table
    
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
      @table[id] = params
      id
    end
  
    def update(id, params)
      if !@table[id.to_s].nil? && !@table[id.to_s].empty?
        @table[id.to_s] = @table[id.to_s].merge(params)
        true
      else
        false
      end
    end    
  
    def all
      @table.query
    end  
  
    def find(id)
      @table[id.to_s]
    end
    
  end

end