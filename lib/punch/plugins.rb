# frozen_string_literal: true

require "logger"
require_relative "plugins/playbox"
require_relative "plugins/preview"

module Punch

  PlayboxPlug = Playbox.plugin
  PreviewPlug = Preview.plugin

  Logger.extend(Plugin)
  LoggerPlug  = Logger.plugin
  LoggerPlug.object = Logger.new(IO::NULL)

end
