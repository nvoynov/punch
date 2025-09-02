require_relative 'named'

module Generator
  module Renderers

    # KPproperty renderer
    class KProperty < Render
      def initialize
        @named = Named.new
      end
      
      def render(model)
        comment = "# @return [#{model.type}] #{model.description}".strip
        comment + NL + "attr_reader :#{@named.render(model)}"
      end
    end
    
  end
end
