# frozen_string_literal: true

require 'clean'
require 'erb'

module Punch

  # Erb generator
  class ErbGen < Clean::Service
    def initialize(erb, model)
      @erb = erb
      @model = model
    end

    def call
      bldr = ERB.new(@erb, trim_mode: '-')
      bldr.result(binding)
    end
  end

end
