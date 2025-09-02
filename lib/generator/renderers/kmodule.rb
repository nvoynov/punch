require_relative 'named'
require_relative 'kproperty'
require_relative 'kmethod'

module Generator
  module Renderers

    # KModule renderer
    class KModule < Render
      def initialize
        @named = Named.new
        @kproperty = KProperty.new
        @kmethod = KMethod.new
      end
      
      def render(model)
        @model = model

        [ required, header, content, footer
        ].reject(&:empty?).join(NN)        
      end

      protected

      attr_reader :model

      def required
        filename = to_filename(model.name)
        (model.required + model.kmodules)
          .map{ to_filename(it.name) }
          .map{ "require_relative \"#{File.join(filename, it)}\"" }
          .join(?\n)
      end

      def header
        model.parents.reverse
          .map.with_index{|e, index| indented(render_header(e), index) }
          .join(NL)
      end

      def footer
        model.parents.size.times
          .map.with_index{|e, index| indented('end', index) }
          .reverse
          .join(NL)
      end

      def content
        kproperties = model.kproperties
          .map{ @kproperty.render(it) }
          .join(NL)

        kmethods = model.kmethods
          .map{ @kmethod.render(it) }
          .join(NN)

        body = [kproperties, kmethods
          ].reject(&:empty?)
           .join(NN)

        [ "# #{model.description}",
          render_header(model),
          body.empty? ? nil : indented(body),
          'end'
        ].compact
         .join(NL)
         .then{ indented(it, model.parents.size) }
      end

      def render_header(model)
        keyword = model.is_a?(Syntax::Klass) ? 'class' : 'module'
        superklass = model.is_a?(Syntax::Klass) && model.superklass ? "< #{model.superklass}" : ''
        "#{keyword} #{@named.render(model)} #{superklass}".strip
      end
      
      def to_filename(str)
        underscore(str).downcase
      end
    end
    
  end
end

# include Generator

# mod = Syntax::KModule.new(name: 'foo', description: 'foo module')
# puts Renderers::KModule.new.render(mod)

# interactor = Syntax::Klass.new(name: 'sign in')
#   .add( Syntax::KProperty.new(name: 'foo') )
#   .add( Syntax::KProperty.new(name: 'bar') )
#   .add( Syntax::KMethod.new(name: 'call',
#     parameters: [Syntax::Parameter.new(name: 'user_id')]
#   ))
# puts Renderers::KModule.new.render(interactor)

# space = Syntax::KModule.new(name: 'interactors')
#   .add(interactor)
# root = Syntax::KModule.new(name: 'clean domain')
#   .add(space)

# puts Renderers::KModule.new.render(interactor)
