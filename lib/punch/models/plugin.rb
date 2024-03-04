# frozen_string_literal: true
module Punch
  module Models

    class Plugin < Data.define(:name, :desc)
      def initialize(name:, desc: '')
        super
      end
    end

  end
end
