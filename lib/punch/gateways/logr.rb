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
          datetime_format: '%Y-%m-%d %H:%M:%S'
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





# logger = Logger.new(STDOUT)
# logger.level = Logger::WARN
#
# logger.debug("Created logger")
# logger.info("Program started")
# logger.warn("Nothing to do!")
#
# path = "a_non_existent_file"
#
# begin
#   File.foreach(path) do |line|
#     unless line =~ /^(\w+) = (.*)$/
#       logger.error("Line in wrong format: #{line.chomp}")
#     end
#   end
# rescue => err
#   logger.fatal("Caught exception; exiting")
#   logger.fatal(err)
# end
#
