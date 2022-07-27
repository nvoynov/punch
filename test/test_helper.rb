# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"

require "punch"
include Punch
include Punch::Gateways

class FileBox
  # Execute block inside temp folder
  def self.call
    Dir.mktmpdir(['punch']) do |dir|
      Dir.chdir(dir) { yield }
    end
  end
end

TMPRX = 'punch'
DUMMY = 'dummy'

def map_logged_to_exist(log)
  # @todo remove CLI::MOTTO
  log.lines
    .reject{|l| l =~ %r{#{CLI::MOTTO}}}
    .map{|l| l.split(?\s).last }
    .map{|f| File.exist?(f) }
end
