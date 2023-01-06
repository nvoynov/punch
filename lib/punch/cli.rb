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

      Usage

        $ punch new PROJECT -v
        $ punch entity NAME [PARA1 PARA2]
        $ punch service NAME [PARA1 PARA2]
        $ punch domain NAME
        $ punch preview entity|service NAME [PARA1 PARA2]

      Samples

        $ punch preview service core/users/create_user name email
        $ punch preview entity user name email
        $ punch preview entity user name "email = nil"
        $ punch preview entity user "answer = \\"42\\"" name "email = nil"
        $ punch preview entity user name: email:
        $ punch preview entity user name: "email: nil"
        $ punch preview entity user name:string "email:string \\"42\\""
        $ punch preview service create_user name email
        $ punch preview service core/users/create_user name email
    EOF

    MOTTO = "Keep code clean, and happy punching!".freeze

  end
end
