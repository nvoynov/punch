# frozen_string_literal: true
module Punch
  module Models

    class Actor < Data.define(:name, :services, :desc)
      def initialize(name:, services: [], desc: '')
        super
      end
    end

  end
end
