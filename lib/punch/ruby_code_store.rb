require_relative 'ports'
require_relative 'hashed'
require 'fileutils'

module Punch

  # Ruby code store adapter
  #   where sources are inside 'lib', and tests in 'tests'
  class RubyCodeStore
    include Ports::Store
    include Hashed
    include FileUtils

    TEST = 'test'
    LIB  = 'lib'
  
    # @param pattern [String]
    # @return [Array<String>]
    def all(pattern = '**/*')
      Dir[pattern]
    end

    def put(filename, content)
      fullname = make_fullname(filename)
      dir = File.dirname(fullname)
      mkdir_p dir unless Dir.exist?(dir)

      unless fullname =~ /.rb$/
        File.write(fullname, content)
        log fullname
        return
      end
    
      if changed_manually?(fullname)
        log "!#{filename}"
        return
      end
    
      File.write(fullname, excerpt(content) + content)
      log fullname
    end

    def get(filename)
      File.read(make_fullname(filename))
    end

    protected

    def log(filename)
      puts "  #{filename}"
    end

    def changed_manually?(filename)
      return false unless File.exist?(filename)
      !correct?(File.read(filename))
    end
    
    def make_fullname(filename)
      return filename unless filename =~ /.rb/
      leaf = (filename =~ /test_\w{1,}.rb/) ? TEST : LIB
      File.join(leaf, filename)
    end
  end
end
