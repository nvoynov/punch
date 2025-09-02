require_relative 'assign'
require_relative 'call_kmethod'

module Generator
  module Renderers

    # Statement renderer like dispacher because only a few statements
    class Statement < Render
      def initialize
        @assign = Assign.new
        @call_kmethod = CallKMethod.new
      end
         
      def render(model)
        case model
        when Syntax::Assign
          @assign.render(model)
        when Syntax::CallKMethod
          @call_kmethod.render(model)
        else
          fail "Unknonw statement #{model}"
        end
      end
    end

  end
end
