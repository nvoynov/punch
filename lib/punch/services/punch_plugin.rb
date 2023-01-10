# frozen_string_literal: true

require_relative "punch_source"

module Punch
  module Services

    # In differs from the PunchSource by punching "config.rb" with plugin hoders
    class PunchPlugin < PunchSource

      CONFIGRB = 'config.rb'.freeze
      # @todo it should be also erb template, and maybe basic.rb
      CONFIGRB_HEADER = <<~EOF.freeze
        require_relative "%s"
        include %s

      EOF

      def requirerb(model)
        super(model)
        location = [config.lib, config.domain, CONFIGRB].reject(&:empty?)
        configrb = File.join(*location)
        holders = if File.exist?(configrb)
          storage.read(configrb)
        else
          @log.concat storage.write(configrb, CONFIGRB_HEADER % [
            config.plugins, config.plugins.capitalize])
          ''
        end
        declare = "#{model.const}Holder = #{model.const}.plugin"
        return if holders =~ %r{#{declare}}
        storage.append(configrb, declare)
        @log << configrb + '~'
      end
    end

  end
end
