require_relative 'expression'

module Generator
  module Syntax
    
    # Operation
    class Operation
      include Expression 

      # @param operation [Symbol]
      # @param operands [Array<Expression>]
      def initialize(operation:, operands:)
        @operation = operation
        @operands = operands
      end
      
      def reducible?
        false
      end

      def reduce(environment)
        self
      end
    end      
  end
end
