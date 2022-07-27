require_relative 'gateways/storage'
require_relative 'gateways/playbox'
require_relative 'gateways/preview'
require_relative 'gateways/logr'

module Punch
  module Gateways
    # port to reach punched directory
    PlayboxPort = Playbox.port

    # port to reach templates, Clean sources, etc.
    StoragePort = Storage.port

    # port for logger
    LoggerPort = Logr.port
  end
end
