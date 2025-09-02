require_relative 'parameter'

module Generator
  module Syntax

    # Klass method
    class KMethod
      include Named

      # @return [Array<Parameter>]
      attr_reader :parameters
      # @return [Array<Statement>]
      attr_reader :statements

      def initialize(name:, parameters: [], statements: [], description: name)
        @name = name.to_s
        @parameters = parameters
        @statements = statements
        @description = description
      end
    end
      
  end
end
