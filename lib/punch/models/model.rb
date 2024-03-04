# frozen_string_literal: true
module Punch
  module Models

    class Model < Data.define(:name, :params, :desc)
      def initialize(name:, params: [], desc: '')
        super
      end
    end

  end
end
