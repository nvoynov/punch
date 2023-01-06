require "logger"
require "forwardable"
require_relative "../basics"

module Punch

  class Logger
    extend Plugin
    extend Forwardable
    def_delegators :@logger, :info, :error
    attr_reader :device

    def initialize(device = IO::NULL)
      @device = device
      @logger = ::Logger.new(device, # 'punch.log',
        datetime_format: '%Y-%m-%d %H:%M:%S',
        formatter: proc{|severity, datetime, progname, msg|
          "[#{datetime}] #{severity.ljust(5)}: #{msg}\n"
        }
      )
    end
  end

end

# LogrPort = Punch::Logger.plug
# LogrPort.plugged = Punch::Logger.new(STDOUT)
#
#
# logger = LogrPort.plugged
# logger.info { 'punch service create_user name email'}
# begin
#   fail StandardError.new('something went wrong')
# rescue => ex
#   logger.error ex
# end
