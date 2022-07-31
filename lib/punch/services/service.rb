# frozen_string_literal: true
require 'clean'
require 'forwardable'

require_relative '../sentries'
require_relative '../values'
require_relative '../gadgets'
require_relative '../gateways'
include Punch::Gateways

module Punch
  module Services

    # Basic Service class
    class Service < Clean::Service
      extend Forwardable
      def_delegator :StoragePort, :gateway, :storage
      def_delegator :PlayboxPort, :gateway, :playbox
    end

  end
end
