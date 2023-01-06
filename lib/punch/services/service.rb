require_relative "../basics"
require_relative "../config"
require_relative "../plugins"
require "forwardable"

module Punch
  module Services

    # Basic Service class
    class Service < Punch::Service
      extend Forwardable
      def_delegator :PlayboxPlug, :object, :storage
      def_delegator :Punch, :config, :config

      # def storage
      #   @storage ||= Home.new
      # end
      #
      # def config
      #   @config ||= Punch.config
      # end
    end

  end
end
