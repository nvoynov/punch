require_relative 'named'
require_relative 'value'

module Generator
  module Renderers

    # Expression renderer
    class Expression < Render
      def initialize
        @named = Named.new
        @value = Value.new
        @operation = nil
      end
        
      def render(model)
        case model
        when Syntax::Named
          @named.render(model)
        when Syntax::Value
          @value.render(model)
        when Syntax::Operation
          @operation.render(model)
        else
          fail "unknown expression #{model}"
        end  
      end
      
    end

  end
end
