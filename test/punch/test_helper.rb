require_relative '../test_helper'
require 'punch'
require 'fileutils'

module PunchHelper

  class LocalStore
    include Punch::Ports::Store
    
    # @param pattern [String]
    # @return [Array<String>]
    def all(pattern = '**/*')
      Dir[pattern]
    end

    # put file to store
    # @param filename [String]
    # @param content [String]
    def put(filename, content)
      dir = File.dirname(filename)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir) 
      File.write(filename, content)
    end

    # get file content from store
    # @param filename [String]
    # @return [String] file content
    def get(filename)
      File.read(filename)
    end
  end

end
