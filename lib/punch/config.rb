require_relative 'ruby_code_store'

module Punch

  CLEAN_CONFIG = 'clean_architecture.yml'
  
  # Configuration
  module Config
    module_function
  
    # @return [Punch::Ports::Store]
    def store
      @store ||= RubyCodeStore.new
    end
  
    def root
      dir = File.dirname(__dir__)
      File.expand_path('..', dir)
    end

    def assets
      File.join(root, 'lib', 'assets')
    end

    def ruby_code_dir
      File.join(assets, 'ruby_code_dir')
    end  
  end
end
