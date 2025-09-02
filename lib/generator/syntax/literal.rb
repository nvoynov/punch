require_relative 'expression'
require_relative 'value'

module Generator
  module Syntax
    
    # Literal
    class Literal
      include Expression 
      include Value 

      def initialize(value:, format: nil)
        @value = value
        @format = farmat
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
