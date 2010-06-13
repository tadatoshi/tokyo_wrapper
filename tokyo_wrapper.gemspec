require 'rake'

Gem::Specification.new do |s|  
  s.name = %q{tokyo_wrapper}  
  s.version = "0.1.11"  

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=  
  s.authors = ["Tadatoshi Takahashi"]  
  s.date = %q{2010-06-13}  
  s.description = %q{Collection of convenient methods written on the top of rufus/tokyo to access Tokyo Cabinet}  
  s.email = %q{tadatoshi.3.takahashi@gmail.com}  
  s.extra_rdoc_files = ["README.rdoc", "lib/tokyo_wrapper.rb"]  
  # s.files = ["README.rdoc", "Rakefile", "lib/tokyo_wrapper.rb", "tokyo_wrapper.gemspec"] 
  s.files = FileList['init.rb', 'lib/**/*.rb', '[A-Z]*', 'spec/**/*'].to_a  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tadatoshi/tokyo_wrapper}  
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Tokyo Wrapper", "--main", "README.rdoc"]  
  s.require_paths = ["lib"]  
  s.rubyforge_project = %q{tokyo_wrapper}  
  s.rubygems_version = %q{1.3.7}  
  s.summary = %q{Collection of convenient methods written on the top of rufus/tokyo to access Tokyo Cabinet}  

  if s.respond_to? :specification_version then  
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION  
    s.specification_version = 3  
        
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, [">= 0.4.0"]) 
      s.add_runtime_dependency(%q<rufus-tokyo>, [">= 1.0.1"])  
    else
      s.add_dependency(%q<ffi>, [">= 0.4.0"])
      s.add_dependency(%q<rufus-tokyo>, [">= 1.0.1"]) 
    end
  else
    s.add_dependency(%q<ffi>, [">= 0.4.0"])
    s.add_dependency(%q<rufus-tokyo>, [">= 1.0.1"])    
  end  
end