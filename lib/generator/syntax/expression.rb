module Generator
  module Syntax

    # Expression interface from Simple language
    module Expression
      def reducible?
        fail "#{self.class}##{__method__} must be implemented"
      end

      def reduce(environment)
        fail "#{self.class}##{__method__} must be implemented"
      end
    end
      
  end
end
