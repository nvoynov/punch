require 'clean'
require 'logger'
require 'forwardable'

module Punch
  module Gateways

    class Logr < Clean::Gateway
      extend Forwardable
      def_delegators :@logger, :info, :error
      attr_reader :device

      def initialize(device = IO::NULL)
        @device = device
        @logger = Logger.new(device, # 'punch.log',
          datetime_format: '%Y-%m-%d %H:%M:%S',
          formatter: proc{|severity, datetime, progname, msg|
            "[#{datetime}] #{severity.ljust(5)}: #{msg}\n"
          }
        )
      end
    end

  end
end

# include Punch::Gateways
# LogrPort = Logr.port
# LogrPort.gateway = Logr.new(STDOUT)
#
#
# logger = LogrPort.gateway
# logger.info { 'punch service create_user name email'}
# begin
#   fail StandardError.new('something went wrong')
# rescue => ex
#   logger.error ex
# end
