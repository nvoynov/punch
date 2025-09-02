require_relative 'render'

module Generator
  module Renderers

    # Named renderer
    class Named < Render
      
      def render(model)
        case model
        when Syntax::Parameter
          underscore(model.name)
        when Syntax::KProperty
          underscore(model.name)
        when Syntax::InstanceVariable
          ?@ + underscore(model.name)
        when Syntax::KMethod
          underscore(model.name)
        when Syntax::KModule
          camelcase(model.name)
        else
          fail "unknown Named #{model}"
        end
      end
    end

  end
end
