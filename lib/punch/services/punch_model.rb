require_relative "service"
require_relative "punch_sentries"

module Punch
  module Services

    # Basic Model Puncher
    # @example
    #   model = Models::Model.new(...)
    #   PunchModel.(model, :entity, conf.entities)
    #
    #
    class PunchModel < Service
      def initialize(model, type, location)
        @model = Decors::Model.new(model, location)
        @type = type
        @location = location
      end

      def call
        @log = []
        # @todo punch sentries
        punch_sentries
        punch
        @log
      end

      def punch_sentries
        sentries = @model.params.select(&:sentry?)
          .map(&:sentry).uniq
          .map{|e| Models::Sentry.new(name: e) }
        @log.concat PunchSentries.(sentries)
      end

      def punch
        src_erb, tst_erb = store.samples(@type)
        @log.concat store.write(srcrb, render(src_erb))
        requirerb
        @log.concat store.write(tstrb, render(tst_erb))
      end

      def render(erb)
        # @model binding automatically
        ERB.new(erb, trim_mode: '%').result(binding)
      end

      def requirerb
        source = store.exist?(reqrb) ? store.read(reqrb) : ''
        reqstr = "require_relative '%s'" % File.join(@location, @model.name)
        return if source =~ %r{reqstr}
        log = store.exist?(reqrb) ? store.append(reqrb, reqstr) : store.write(reqrb, reqstr)
        @log.concat log 
      end

      def getrb(head, tail = @model.name)
        [head, conf.domain, @location, tail].reject(&:empty?)
          .then{|a| File.join(a) + '.rb' }
      end

      def srcrb
        getrb(conf.lib)
      end

      def tstrb
        getrb(conf.test).split(PATH_SEPARATOR)
          .tap{|a| a.push('test_' + a.pop) }
          .then{ File.join(_1) }
      end

      PATH_SEPARATOR = %r{[\\\/]}.freeze

      def reqrb
        [conf.lib, conf.domain, @location].reject(&:empty?)
          .then{ File.join(_1) + '.rb' }
      end
    end

  end
end
