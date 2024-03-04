# frozen_string_literal: true
module Punch
  module Models

    class Sentry < Data.define(:name, :desc, :proc)
      def initialize(name:, desc: '', proc: "fail \"desing the sentry\"")
        super
      end
    end

  end
end
