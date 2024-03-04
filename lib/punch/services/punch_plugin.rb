require_relative 'service'

module Punch
  module Services

    class PunchPlugin < PunchModel
      # @param model [Models::Plugin]
      def initialize(model)
        super(model, :plugin, conf.plugins)
      end

      # @todo PunchModel should not punch sentries
      #   but PunchEntity and PunchService sould!
      def call
        @log = []
        punch
        @log
      end

      protected

      def requirerb
        # the same part as for PunchModel
        source = store.exist?(reqrb) ? store.read(reqrb) : ''
        reqstr = "require_relative '%s'" % File.join(@location, @model.name)
        return if source =~ %r{reqstr}
        # but for plugin there should be also PluginHodler = Plugin.plugin
        hldstr = "#{@model.const}Holder = #{@model.const}.plugin"
        @log.concat "#{reqstr}\n#{hldstr}".then{|str|
          store.exist?(reqrb) ? store.append(reqrb, str) : store.write(reqrb, str)
        }
      end
    end

  end
end
