require_relative 'make_dsl'

module CleanArchitecture
  module DSL

    class KMethod
      include MakeDSL

      def initialize(name, description = '')
        @name = name
        @description = description
        @parameters = []
      end

      def model
        Generator::Syntax::KMethod.new(
          name: @name,
          parameters: @parameters,
          description: @description)
      end

      def parameter(name, description)
        Generator::Syntax::Parameter.new(name:, description:)
          .tap{ @parameters << it }
      end
    end
    
  end
end
