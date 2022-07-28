# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"

require "punch"
include Punch
include Punch::Gateways

class FileBox
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
        playbox = Gateways::PlayboxPort.gateway
        playbox.punch_dir(DUMMY)
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

def print_debug_info(message = '')
  puts "\ndebug>> #{message}"
  puts Dir.pwd
  pp Dir.glob('**/*')
end
