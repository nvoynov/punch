# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"
# require_relative "../lib/punch"
require "punch"
include Punch

class Tempbox
  # Execute block inside temp folder
  def self.call
    Dir.mktmpdir([TMPRX]) do |dir|
      Dir.chdir(dir) { yield }
    end
  end
  TMPRX = 'punchbox'.freeze
end

class Sandbox
  def self.call
    Dir.mktmpdir([TMPRX]) do |dir|
      Dir.chdir(dir) do
        playbox = PlayboxHolder.object
        playbox.punch_home(DUMMY)
        Dir.chdir(DUMMY){ yield }
      end
    end
  end

  TMPRX = 'punch'.freeze
  DUMMY = 'dummy'.freeze
end

def map_logged_to_exist(log)
  # @todo remove CLI::MOTTO
  log.lines
    .reject{|l| l =~ %r{#{CLI::MOTTO}}}
    .map{|l| l.split(?\s).last }
    .map{|f| File.exist?(f) }
end

def print_folders(pat = '**/*')
  puts "\n--- #{Dir.pwd}\n"
  puts Dir.glob(pat, File::FNM_DOTMATCH)
end

def print_content(*names)
  names.each do |source|
    puts "\n--- #{source}\n#{File.read(source)}\n"
  end
end
