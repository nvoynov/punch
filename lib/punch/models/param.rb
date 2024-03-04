# frozen_string_literal: true
module Punch
  module Models

    class Param < Data.define(:name, :sentry, :default, :desc)
      def initialize(name:, sentry: nil, default: nil, desc: '')
        super
      end

      def <=>(another)
        return nil unless self.class == another.class
        return   1 if default && another.default.nil?
        return  -1 if default.nil? && another.default
        0
      end

      def sentry? = !sentry.nil?
      def default? = !default.nil?
    end

  end
end
