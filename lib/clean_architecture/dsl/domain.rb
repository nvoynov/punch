require_relative 'entity'
require_relative 'interactor'
# require_relative 'dsl/make_domain'
# require_relative 'dsl/make_interactor'
# require_relative 'dsl/make_entity'
# require_relative 'dsl/make_port'

module CleanArchitecture

  # DSL namespace
  module DSL

    class Domain
      include MakeDSL

      def initialize(name)
        @domain = Builders::BuildDomain.call(name)
      end

      def model
        @domain
      end

      def interactor(name, description = '', &block)
        Interactor.make(name, description, &block)
          .tap{ @domain.interactors.add(it) }
      end
      
      def entity(name, description = '', &block)
        Entity.make(name, description, &block)
          .tap{ @domain.entities.add(it) }
      end

      def port(name, description = '', &block)
        Port.make(name, description, &block)
          .tap{ @domain.ports.add(it) }
      end
    end
    
  end
end
