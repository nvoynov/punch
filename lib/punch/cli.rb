# frozen_string_literal: true

require "forwardable"
require_relative "version"
require_relative "services"
require_relative "gateways"
include Punch::Gateways

module Punch

  module CLI
    extend self
    extend Forwardable
    def_delegator :PlayboxPort, :gateway, :playbox
    def_delegator :LoggerPort, :gateway, :logger

    def unknown(command)
      puts "Unknown command \"#{command}\"!"
      puts banner
    end

    def exit_with_message(msg, cnd)
      return if cnd
      puts msg
      exit(0)
    end

    def create(dir)
      exit_with_message("PROJECT parameter required", !!dir)
      log_and_rescue {
        logger.info { "new #{dir}" }
        playbox.punch_dir(dir).tap{|_| motto}
      }
    end

    def init
      log_and_rescue {
        logger.info { "init" }
        playbox.punch_pwd.tap{|_| motto}
      }
    end

    def clone(lib)
      exit_with_message("run as '$ punch clone clean'", !!lib && lib == 'clean')
      log_and_rescue {
        logger.info { "clone #{lib}" }
        playbox.clone_clean_sources
      }
    end

    # @param args [*Array] like ARGV
    def punch(*args)
      log_and_rescue {
        logger.info { "punch #{args.join(?\s)}" }
        Services::Punch.(*args)
      }
    end

    def preview(*args)
      # just change gateway!
      PlayboxPort.gateway = Preview.new
      punch(*args)
      # log_and_rescue do
        # Sandbox.() {
        #   logger.info { "preview #{args}" }
        #   log = Services::Punch.(*args)
        #   log.map{|l| l.split(?\s).last}
        #     .each{|f|
        #       puts "\n# #{'-' * f.size}"
        #       puts "# #{f}"
        #       puts "# #{'-' * f.size}\n"
        #       puts File.read(f)
        #     }
        # }
      # end
    end

    def log_and_rescue(context = '')
      log = yield
      return if log.empty?
      log.map{|item|
        actn = item =~ /~$/ ? 'backup' : 'create'
        puts "  #{actn} #{item}"
      }
      logger.info(log.is_a?(Array) ? log.join(", ") : log)
    rescue StandardError => ex
      logger.error(ex)
      puts <<~EOF
        #{ex.message} (#{ex.class.name})
        see the error details inside #{logger.device}
      EOF
    end

    def banner
      BANNER
    end

    def motto
      puts MOTTO
    end

    MOTTO = "Keep code clean, and happy punching!".freeze

    BANNER = <<~EOF.freeze

     - Punch v#{Punch::VERSION} Clean Code Puncher -

     To learn more about punch visit
       https://github.com/nvoynov/punch
       https://github.com/nvoynov/clean

     Quickstart
       1. gem "punch" to Gemfile
       2. $ punch

     Usage
       $ punch new PROJECT
       $ punch init
       $ punch clone clean
       $ punch sentry NAME [PARA1 PARA2]
       $ punch entity NAME [PARA1 PARA2]
       $ punch service NAME [PARA1 PARA2]
       $ punch geteway NAME
       $ punch preview sentry|entity|service|gateway
    EOF
  end

end
