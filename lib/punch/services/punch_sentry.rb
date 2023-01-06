# frozen_string_literal: true

require "erb"
require_relative "service"
require_relative "../decors"

module Punch
  module Services

    MustbeSentryArray = Sentry.new(:args, 'must be Array<Punch::SentryModel>'
    ) {|v| v.is_a?(Array) && v.any? && v.all?{|i| i.is_a?(Punch::SentryModel)} }

    # Punches bunch of Sentries from *args
    # @param *args [Array<SentryModel>]
    # @return [Array<String>] with punched sources
    class PunchSentry < Service

      def call
        MustbeSentryArray.(@args)
        @log, @buffer = [], []
        @source, @test = storage.samples(:sentry)
        @args.map{|m| decorator(m) }
          .reject{|d| declared?(d.const)}
          .each  {|d| punch(d)}
        return [] if @buffer.empty? # nothing was punched

        storage.append(@sentries_source, @buffer.join(?\n) )
        @log.unshift @sentries_source
      end

      protected

      def decorator(model)
        Factory.decorate(:sentry, model)
      end

      def sentries_source
        @sentries_source ||= File.join(config.lib, config.sentries + '.rb')
      end

      def punch(model)
        @buffer << render(@source, model)
        # storage.write(decor.sorce, source)
        test = render(@test, model)
        storage.write(model.test, test)
        @log << model.test
      end

      def render(erb, model)
        @model = model
        renderer = ERB.new(erb, trim_mode: '-')
        renderer.result(binding)
      end

      # @return true when the const already declared in sentries.rb
      def declared?(const)
        declared.include?(const)
      end

      def declared
        @declared ||= begin
          sentries = if storage.exist?(sentries_source)
            storage.read(sentries_source)
          else
            storage.append(sentries_source, SENTRIES)
            SENTRIES
          end
          sentries.lines
            .select{|l| l.match?(/Sentry.new/)}
            .map{|l| l.split(?\s).first.strip }
        end
      end

      SENTRIES = <<~EOF.freeze
        # frozen_string_literal: true

        require_relative "punch"
        include Punch

        # MustbeString
        MustbeString = Sentry.new(:key, 'must be String') {|v| v.is_a?(String)}

      EOF
    end

  end
end
