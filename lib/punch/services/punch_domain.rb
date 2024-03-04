# frozen_string_literal: true

require_relative "service"
require_relative "punch_sentries"
require_relative "punch_model"
require_relative "punch_plugin"

module Punch
  module Services

    MustbeDomain = Sentry.new(:domain, 'must be Punch::Models::Domain'
    ) {|v| v.is_a?(Punch::Models::Domain)}

    class PunchDomain < Service
      def call
        log = []
        domain = MustbeDomain.(@args[0])
        @block = proc{|event, payload|} unless @block

        if domain.sentries.any?
          @block.(:stage, 'sentries')
          log.concat PunchSentries.(domain.sentries)
        end

        if domain.entities.any?
          @block.(:stage, 'entities')
          domain.entities.each{|e|
            log.concat PunchModel.(e, :entity, conf.entities)
          }
        end

        services = Array.new(domain.services)
        services.concat domain.actors.inject([]){|memo, a|
          memo.concat a.services.map{|s|
            s.with(name: a.name.to_s + ?\s + s.name.to_s)
          }
        }

        if services.any?
          @block.(:stage, 'services')
          services.each{|e|
            log.concat PunchModel.(e, :service, conf.services)
          }
        end

        if domain.plugins.any?
          @block.(:stage, 'plugins')
          domain.plugins.each{|e|
            log.concat PunchPlugin.(e)
          }
        end

        log.uniq!
        return log if conf.domain.empty?

        reqstr = "require_relative \"#{conf.domain}/%s\""
        content = []
        content << reqstr % "basics"
        content << reqstr % conf.sentries if domain.sentries.any?
        content << reqstr % conf.entities if domain.entities.any?
        content << reqstr % conf.services if services.any?
        content << reqstr % conf.plugins  if domain.plugins.any?
        domainrb = File.join(conf.lib, conf.domain + '.rb')
        log.concat store.write(domainrb, content.join(?\n))
        log.reject{|s| s =~ /~$/}.sort
      end
    end

  end
end
