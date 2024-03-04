# frozen_string_literal: true

require "logger"
require_relative "plugins/playbox"
require_relative "plugins/preview"
require_relative "config"

module Punch

  PlayboxHolder = Playbox.plugin
  PreviewHolder = Preview.plugin

  Logger.extend(Plugin)
  LoggerHolder = Logger.plugin

end
