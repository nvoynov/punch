require_relative '../../basic'
require_relative '../syntax'

module Generator
  module Renderers

    # Render basic interface
    class Render
      def render(model)
        fail "#{self.class}##{__method__} must be overridden"
      end

      protected

      NL = ?\n
      NN = "\n\n"
      
      def indented(str, level = 1)
        str.lines
          .map{ "  " * level + it }
          .join
      end

      def underscore(str)
        str.sanitize.underscore.downcase
      end

      def camelcase(str)
        underscore(str).camelcase
      end
    end
    
  end
end

