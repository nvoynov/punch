# frozen_string_literal: true

require "erb"
require_relative "../decors"
require_relative "service"
require_relative "punch_sentry"

module Punch
  module Services

    MustbeModelArray = Sentry.new(:args, 'must be Array<Punch::Model>'
    ) {|v| v.is_a?(Array) && v.any? && v.all?{|i| i.is_a?(Punch::Model)} }

    MustbeKlassDecor = Sentry.new(:args0, 'must be :sentry|:entity|:service|:plugin'
    ) {|v| v.is_a?(Symbol) && %i(sentry entity service plugin).any?{|s| s == v} }

    # Punches bunch of models from *args
    #
    # @example
    #   signup = Model.new('user/signup')
    #   signin = Model.new('user/signin')
    #   PunchSource.(:service, signup, signin)
    #   # => [
    #   #     'lib/services.rb',
    #   #     'lib/services.rb~',
    #   #     'lib/services/signup.rb',
    #   #     'test/services/test_signup.rb',
    #   #     'lib/services/signin.rb',
    #   #     'test/services/test_signin.rb'
    #   # ]
    #
    # @param *args [klass, Array<Model>]
    # @return [Array<String>] with punched sources
    class PunchSource < Service

      def call
        @klass = MustbeKlassDecor.(@args.shift)
        MustbeModelArray.(@args)
        storage.punch_basics
        decorator(@args.first) # must fail for unknown klass
        @log = []
        payload = sentries
        @log.concat PunchSentry.(*payload) if payload.any?

        @source, @test = storage.samples(@klass)
        @args.map{|m| decorator(m) }
            .each{|d| punch(d) }
        @log
      end

      protected

      def decorator(model)
        Factory.decorate(@klass, model)
      end

      def sentries
        fn = proc{|memo, model|
          memo.concat(
            model.params
              .select(&:sentry?)
              .map(&:sentry)
          )
        }
        @args.inject([], &fn).uniq
          .map{|s| SentryModel.new(s)}
      end

      def punch(model)
        source = render(@source, model)
        @log.concat storage.write(model.source, source)
        requirerb(model)
        test = render(@test, model)
        @log.concat storage.write(model.test, test)
      end

      def requirerb(model)
        required = ''
        required = storage.read(model.require) if storage.exist?(model.require)
        requires = "require_relative \"#{model.require_string}\""
        return if required =~ %r{#{requires}}
        storage.append(model.require, requires)
        @log << model.require + '~'
      end

      def render(erb, model)
        @model = model
        renderer = ERB.new(erb, trim_mode: '-')
        renderer.result(binding)
      end
    end

  end
end
