require 'delegate'
require 'forwardable'

module Punch
  module Decors

    class Decor < SimpleDelegator
      extend Forwardable
      def_delegator :ConfigHolder, :object, :conf

      def initialize(model, context = nil)
        super(model)
        @context = context
      end

      def name
        sanitize(super)
      end

      protected

      attr_reader :context

      def sanitize(arg)
        String.new( arg.is_a?(String) ? arg : arg.to_s)
          .gsub(/[^\w\s]/, ?\s)
          .gsub(/\s{1,}/, '_')
      end
    end

  end
end
