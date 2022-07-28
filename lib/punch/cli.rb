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
      # punch(*args) is already wrapped in log_and_rescue!
      PlayboxPort.gateway = Preview.new
      logger.info { "Playbox changed to preview" }
      logger.info { "preview #{args.join(?\s)}"  }
      punch(*args)
    end

    def log_and_rescue
      log = yield
      # @todo ensure that result yeild is array of string?
      unless !!log && log.is_a?(Array) && log.any?
        logger.info { "no result returned" }
        return
      end
      logger.info(log.is_a?(Array) ? log.join(", ") : log)
      return unless log.is_a?(Array)
      log.map{|item|
        actn = item =~ /~$/ ? 'backup' : 'create'
        puts "  #{actn} #{item}"
      }
    # something that we wait for
    rescue StandardError => ex
      logger.error(ex)
      puts <<~EOF
        #{ex.message} (#{ex.class.name})
        see the error details inside #{logger.device}
      EOF
    # some unexpected
    rescue => ex
      puts ex
    end

    def motto
      puts MOTTO
    end

    MOTTO = "Keep code clean, and happy punching!".freeze
  end

end
