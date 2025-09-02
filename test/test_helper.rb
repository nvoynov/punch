# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "punch"

require "minitest/autorun"
require "minitest/pride"
 
SYN = Generator::Syntax
  
def temp_directory
  Dir.mktmpdir{|tmp|
    Dir.chdir(tmp){
      yield
    }
  }
end
