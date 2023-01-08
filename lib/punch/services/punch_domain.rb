# frozen_string_literal: true

require_relative "../decors"
require_relative "service"
require_relative "punch_sentry"
require_relative "punch_source"

module Punch
  module Services

    MustbeDomain = Sentry.new(:domain, 'must be Punch::DSL::Domain'
    ) {|v| v.is_a?(Punch::DSL::Domain)}

    class PunchDomain < Service
      def call
        @domain = MustbeDomain.(@args[0])
        @block = proc{|event, payload|} unless @block

        @block.(:stage, 'sentries')
        payload = @domain.sentries
        PunchSentry.(*payload) if payload.any?

        @block.(:stage, 'entities')
        payload = @domain.entities
        PunchSource.(:entity, *payload) if payload.any?

        @block.(:stage, 'services')
        payload = @domain.services
        PunchSource.(:service, *payload) if payload.any?

        @domain.actors.each{|actor|
          @block.(:stage, "'#{actor.name}' services")
          payload = actor.services
          PunchSource.(:service, *payload) if payload.any?
        }
      end
    end

  end
end
