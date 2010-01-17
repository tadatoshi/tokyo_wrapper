module RufusTokyoMacros
  
  def clear_table(file)
    if File.exists?(File.expand_path(file))
      table = Rufus::Tokyo::Table.new(File.expand_path(file), :mode => "wf")
      table.clear
      table.close
    end
  end
  
end