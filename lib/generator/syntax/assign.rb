require_relative 'named'
require_relative 'expression'

module Generator
  module Syntax

    # Assign
    class Assign
      # @return [Named]
      attr_reader :named
      # @return [Expression]
      attr_reader :expression
      
      def initialize(named, expression)
        @named = named
        @expression = expression
      end
    end
      
  end
end
