# frozen_string_literal: true

require_relative "../decors"
require_relative "service"
require_relative "punch_sentry"
require_relative "punch_source"
require_relative "punch_plugin"

module Punch
  module Services

    MustbeDomain = Sentry.new(:domain, 'must be Punch::DSL::Domain'
    ) {|v| v.is_a?(Punch::DSL::Domain)}

    class PunchDomain < Service
      def call
        log = []
        @domain = MustbeDomain.(@args[0])
        @block = proc{|event, payload|} unless @block

        payload = @domain.sentries
        @block.(:stage, 'sentries') if payload.any?
        log.concat PunchSentry.(*payload) if payload.any?

        payload = @domain.entities
        @block.(:stage, 'entities') if payload.any?
        log.concat PunchSource.(:entity, *payload) if payload.any?

        payload = @domain.services
        @block.(:stage, 'services') if payload.any?
        log.concat PunchSource.(:service, *payload) if payload.any?

        payload = @domain.plugins
        @block.(:stage, 'plugins') if payload.any?
        log.concat PunchPlugin.(:plugin, *payload) if payload.any?

        log.uniq!
        return log if config.domain.empty?

        reqstr = "require_relative \"#{config.domain}/%s\""
        content = []
        content << reqstr % "basics"
        content << reqstr % "config"
        content << reqstr % config.sentries if @domain.sentries.any?
        content << reqstr % config.entities if @domain.entities.any?
        content << reqstr % config.services if @domain.services.any?
        content << reqstr % config.plugins  if @domain.plugins.any?
        domainrb = File.join(config.lib, config.domain + '.rb')
        log.concat storage.write(domainrb, content.join(?\n))
        log
      end
    end

  end
end
