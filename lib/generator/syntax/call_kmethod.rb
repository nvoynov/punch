require_relative 'kmethod'

module Generator
  module Syntax

    # Call Method
    class CallKMethod
      # @return [KMethod]
      attr_reader :kmethod
      # @return [Array<Expression>]
      attr_reader :arguments
      
      def initialize(kmethod:, arguments: [])
        @kmethod = kmethod
        @arguments = arguments
      end
    end
      
  end
end
