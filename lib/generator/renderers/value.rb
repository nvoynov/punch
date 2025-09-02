require_relative 'render'

module Generator
  module Renderers

    # Value renderer
    class Value < Render
      def initialize
        @default_formats = {
          String  => "\"%s\"",
          Integer => "%d",
          Float   => "%f"
        }
      end
        
      def render(model)
        format_string = model.format || @default_formats[model.value.class]
        sprintf(format_string, model.value)
      end
    end

  end
end
