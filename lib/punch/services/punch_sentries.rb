require 'erb'
require_relative 'service'

module Punch
  module Services

    protected

    class PunchSentries < Service
      # @param models [Array<Models::Sentry>]
      def initialize(models)
        @models = models.map{|e| Decors::Sentry.new(e) }
      end

      # @return [Array<String>] log of punched files
      def call
        @log, @buffer = [], []
        @srcerb, @tsterb = store.samples(:sentry)
          .then{|src, tst| [
            ERB.new(src, trim_mode: '%<>'),
            ERB.new(tst, trim_mode: '%<>')
          ]}
        punched = already_punched
        @models
          .reject{|e| punched.include?(e.const) }
          .each(&method(:punch))
        return [] if @buffer.empty? # nothing was punched

        store.append(srcrb, @buffer.join(?\n) )
        @log.unshift srcrb
      end

      protected

      def punch(model)
        @model = model
        @buffer << @srcerb.result(binding)
        body = @tsterb.result(binding)
        file = tstrb(model.name)
        store.write(file, body)
        @log << file
      end

      def already_punched
        unless File.exist?(srcrb)
          store.append(srcrb, STARTER)
          []
        end

        File.read(srcrb).lines
          .select{|l| l.match?(/Sentry.new/)}
          .map{|l| l.split(?\s).first.strip }
      end

      def srcrb
        [conf.lib, conf.domain, conf.sentries].reject(&:empty?)
          .then{ File.join(_1) + '.rb' }
      end

      def tstrb(name)
        [ conf.test, conf.domain, conf.sentries, 'test_' + name
        ].reject(&:empty?)
          .then{ File.join(_1) + '.rb' }
      end

      STARTER = <<~EOF.freeze
        # frozen_string_literal: true
        require_relative "basics"

      EOF
    end

  end
end
