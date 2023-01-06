# frozen_string_literal: true

require_relative "punch/version"
require_relative "punch/basics"
require_relative "punch/model"
require_relative "punch/dsl"    # model/dsl?
require_relative "punch/decors" # model/decor?
require_relative "punch/services"
require_relative "punch/plugins"
require_relative "punch/cli"

module Punch

  # class << self
  #
  #   def root
  #     File.dirname __dir__
  #   end
  #
  #   def self.assets
  #     File.join(root, 'lib', 'assets')
  #   end
  #
  #   def self.sources
  #     File.join(root, 'lib', 'punch')
  #   end
  # end

end
