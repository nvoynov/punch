# frozen_string_literal: true

require_relative "../model"

module Punch
  module DSL

    class Sentry < Punch::SentryModel
    end

    module ParamMixin
      def param(name, desc = '', keyword: true, default: nil, sentry: '')
        para = Param.new(name, desc,
          keyword: keyword,
          default: default,
          sentry: sentry)
        self.<<(para)
      end
    end

    class Entity < Punch::Model
      include ParamMixin
    end

    class Service < Punch::Model
      include ParamMixin
    end

    class Actor < Punch::Basic
      attr_reader :services

      def initialize(name, desc = '')
        super(name, desc)
        @services = {}
      end

      def <<(service)
        fail ArgumentError, "Service required" unless service.is_a? Service
        @services[service.name] = service
      end

      def service(name, desc = '', &block)
        service = Service.new(name, desc)
        service.instance_eval(&block) if block
        self.<<(service)
      end

    end

    class Domain < Punch::Basic
      attr_reader :sentries
      attr_reader :entities
      attr_reader :actors

      def initialize(name, desc = '')
        super(name, desc)
        @sentries = {}
        @entities = {}
        @actors = {}
      end

      def add_sentry(sentry)
        @sentries[sentry.name] = sentry
      end

      def add_entity(entity)
        @entities[entity.name] = entity
      end

      def add_actor(actor)
        @actors[actor.name] = actor
      end
    end

  end
end
