require_relative 'make_dsl'

module CleanArchitecture
  module DSL

    class Entity
      include MakeDSL

      def initialize(name, description = '')
        @name = name
        @description = description
        @properties = []
      end

      def model
        domain = Builders::BuildDomain.call('domain')
        Builders::BuildEntity.call(@name, @properties, domain)
      end

      def property(name, description)
        Generator::Syntax::KProperty.new(name:, description:)
          .tap{ @properties << it }
      end
    end
    
  end
end
