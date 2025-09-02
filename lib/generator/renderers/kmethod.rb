require_relative 'named'
require_relative 'statement'

module Generator
  module Renderers

    # KMethod renderer
    class KMethod < Render
      def initialize
        @named = Named.new
        @statement = Statement.new
      end
      
      def render(model)
        @model = model
        render_comment + NL + render_method
      end

      protected

      attr_reader :model

      def render_comment
        model.parameters
          .map{ "# @param #{@named.render(it)} [#{it.type}] #{it.description}".strip }
          .join(NL)
      end

      def render_params
        model.parameters
          .map{ @named.render(it) }
          .join(', ')
          .then{ it.empty? ? '' : "(#{it})" }
      end

      def render_statements
        return 'fail "#{self.class}##{__method__} must be implemented"' \
          unless model.statements.any?

        model.statements
          .map{ @statement.render(it) }
          .join(NL) 
      end

      def render_method
        <<~STR.strip
          def #{@named.render(model)}#{render_params}
          #{indented(render_statements)}
          end
        STR
      end 
    end
    
  end
end
