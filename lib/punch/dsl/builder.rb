# frozen_string_literal: true

require_relative "domain"

module Punch
  module DSL

    class Builder
      attr_reader :domain

      def self.build(&block)
        bldr = new
        bldr.instance_eval(&block)
        bldr.domain
      end

      def initialize
        @domain = Domain.new(:domain)
      end
      private_class_method :new

      def sentry(name, desc = '', block: '')
        @domain.add_sentry(
          Sentry.new(name, desc, block: block)
        )
      end

      def entity(name, desc = '', &block)
        entity = Entity.new(name, desc)
        entity.instance_eval(&block) if block
        @domain.add_entity(entity)
      end

      def service(name, desc = '', &block)
        service = Service.new(name, desc)
        service.instance_eval(&block) if block
        @domain.add_service(service)
      end

      def actor(name, desc = '', &block)
        actor = Actor.new(name, desc)
        actor.instance_eval(&block)
        @domain.add_actor(actor)
      end
    end

  end
end
