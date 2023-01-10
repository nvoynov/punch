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

    class Plugin < Punch::Model
      include ParamMixin
    end

    class Actor < Punch::Basic
      def initialize(name, desc = '')
        super(name, desc)
        @services = {}
      end

      def <<(service)
        fail ArgumentError, "Service required" unless service.is_a? Service
        @services[service.name] = service
      end

      def service(name, desc = '', &block)
        service = Service.new("#{@name} #{name}", desc)
        service.instance_eval(&block) if block
        self.<<(service)
      end

      def services
        @services.values
      end

    end

    class Domain < Punch::Basic

      def initialize(name, desc = '')
        super(name, desc)
        # Hash<name, object> to ensure uniq names
        @sentries = {}
        @entities = {}
        @services = {}
        @plugins = {}
        @actors = {}
      end

      def add_sentry(sentry)
        @sentries[sentry.name] = sentry
      end

      def add_entity(entity)
        @entities[entity.name] = entity
      end

      def add_service(service)
        @services[service.name] = service
      end

      def add_actor(actor)
        @actors[actor.name] = actor
      end

      def add_plugin(plugin)
        @plugins[plugin.name] = plugin
      end

      def sentries
        @sentries.values
      end

      def entities
        @entities.values
      end

      def services
        Array.new(@services.values).tap{|ary|
          actors.each{|a|
            ary.concat(a.services)
          }
        }
      end

      def actors
        @actors.values
      end

      def plugins
        @plugins.values
      end

    end

  end
end
