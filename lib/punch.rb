# frozen_string_literal: true

require_relative "punch/version"
require_relative "punch/gadgets"
require_relative "punch/sentries"
require_relative "punch/services"
require_relative "punch/values"
require_relative "punch/gateways"
require_relative "punch/cli"

module Punch
  Error = Class.new(StandardError)

  def self.root
    File.dirname __dir__
  end

  def self.assets
    File.join(root, 'lib', 'assets')
  end

  def self.error!(msg)
    fail Error, msg
  end

end
