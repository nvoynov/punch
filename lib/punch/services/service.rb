require_relative "../basics"
require_relative "../models"
require_relative "../decors"
require_relative "../plugins"
require "forwardable"

module Punch
  module Services

    # Basic Service class
    class Service < Punch::Service
      extend Forwardable
      def_delegator :PlayboxHolder, :object, :store
      def_delegator :ConfigHolder, :object, :conf
    end

  end
end
