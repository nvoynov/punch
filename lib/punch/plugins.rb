# frozen_string_literal: true

require_relative "plugins/playbox"
require_relative "plugins/preview"
require_relative "plugins/logger"

module Punch

  PlayboxPlug = Playbox.plugin
  PreviewPlug = Preview.plugin
  LoggerPlug  = Logger.plugin

end
