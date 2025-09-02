require_relative 'named'
require_relative 'expression'

module Generator
  module Renderers

    # Assign Statement renderer
    class Assign < Render
      def initialize
        @named = Named.new
        @expression = Expression.new
      end
      
      def render(model)
        [ @named.render(model.named),
          @expression.render(model.expression)          
        ].join(' = ')
      end
    end

  end
end
