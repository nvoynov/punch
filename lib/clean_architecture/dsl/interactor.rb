require_relative 'make_dsl'

module CleanArchitecture
  module DSL

    class Interactor
      include MakeDSL

      def initialize(name, description = '')
        @name = name
        @description = description
        @parameters = []
      end

      def model
        domain = Builders::BuildDomain.call('domain')
        Builders::BuildInteractor.call(@name, @parameters, domain)
      end

      def parameter(name, description = '')
        Generator::Syntax::Parameter.new(name:, description:)
          .tap{ @parameters << it }
      end
    end
    
  end
end
