# frozen_string_literal: true

require_relative "model"
require_relative "plugins"
require_relative "version"
require "forwardable"

module Punch
  module CLI
    extend self
    extend Forwardable
    def_delegator :PlayboxPlug, :object, :playbox
    def_delegator :LoggerPlug,  :object, :logger

    # create new Punch project
    # @param dir [String] project directory name
    def folder(dir)
      secure_call {
        logger.info { "new #{dir}" }
        playbox.punch_home(dir)
      }
    end

    # punch new entity or service source
    # @param *args [Array<String>] where the first item
    #   must be model klass :entity or :service,
    #   the rest items are klass parameters
    #
    # I can't see any sense to punch just sentry there
    def source(*args)
      pp args
      pp ARGV
      return unless playbox.punch_home?

      klass = args.shift.downcase.to_sym
      unless %i[entity service].include?(klass)
        puts "required 'entity' or 'service'"
        return
      end

      secure_call {
        logger.info { "punch #{args.join(?\s)}" }
        model = ModelBuilder.(*args)
        Services::PunchSource.(klass, model)
      }
    end

    # preview the result of the punch
    def preview(*args)
      return unless punch_home?
      PlayboxPlug.plugin Preview
      logger.info { "preview #{args.join(?\s)}"  }
      source(*args)
    end

    def domain
      return unless playbox.punch_home?
      if Dir.exist? Playbox::DOMAIN
        puts "\"#{Playbox::DOMAIN}\" directory exist already"
        return
      end
      secure_call {
        logger.info { "punch domain" }
        playbox.punch_domain
      }
    end

    # report project status
    def status
      return unless punch_home?
      puts Services::ReportStatus.()
    end

    def banner
      puts BANNER
    end

    def punch_home?
      msg = "Run the command inside \"punched\" project!"
      puts msg unless playbox.punch_home?
      playbox.punch_home?
    end

    protected

    def exit_unless(condition, message = '')
      return if condition
      puts message
      exit(0)
    end

    def print_motto
      puts MOTTO
    end

    def secure_call
      log = yield
      # @todo ensure that result yeild is array of string?
      unless !!log && log.is_a?(Array) && log.any?
        logger.info { "no result returned" }
        return
      end
      logger.info(log.is_a?(Array) ? log.join(", ") : log)
      return unless log.is_a?(Array)
      log.map{|item|
        action = case item
        when /~$/
          'backup'
        when /!$/
          'ignore'
        else
          'create'
        end
        puts "  #{action} #{item}"
      }
    # something that we wait for
    rescue StandardError => ex
      logger.error(ex)
      puts <<~EOF
        #{ex.message} (#{ex.class.name})
        See '#{logger.device}' for details
      EOF
    # some unexpected
    rescue => ex
      puts ex
    end

    BANNER = <<~EOF.freeze

      ~ Punch v#{Punch::VERSION} ~ Code Generator
      https://github.com/nvoynov/punch

      Usage:

        punch new|n DIRECTORY [OPTIONS]    Create a new Punch project
          -e, --editor EDITOR              Open the project in EDITOR

        punch entity|e NAME [PARAM..]      Punch new entity concept
          PARAM: name[:][sentry][default]  zero or more parameters

        punch service|s NAME [PARAM..]     Punch new service concept
          PARAM: name[:][sentry][default]  zero or more parameters

        punch preview COMMAND              Preview generation result
          entity|e NAME [PARAM..]          command to preview...
          service|s NAME [PARAM..]

        punch status                       Print Punch Project status

        punch domain                       Copy domain DSL example

      Feel free to run a few preview before start punching:

        $ punch preview service signup name email
        $ punch preview service user/signup name "email pa$$w0rd"
        $ punch preview service user/signup name: email:
        $ punch preview service user/signin login:email secret:secret
        $ punch preview service user/signin login:email "secret:secret "pa$$w0rd""
    EOF

    MOTTO = "Keep code clean, and happy punching!".freeze

  end
end
