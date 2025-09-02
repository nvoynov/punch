require_relative 'named'
require_relative 'expression'

module Generator
  module Renderers

    # Call kmehod renderer
    class CallKMethod < Render
      def initialize
        @named = Named.new
        @expression = Expression.new
      end
        
      def render(model)
        @named.render(model.kmethod) + render_arguments(model.arguments)
      end

      protected

      def render_arguments(args)
        args
          .map{ @expression.render(it) }
          .join(', ')
          .then{ it.empty? ? '' : "(#{it})"}
      end
      
    end

  end
end
