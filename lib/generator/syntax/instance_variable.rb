require_relative 'named'

module Generator
  module Syntax

    # Klass instance variable
    # TODO: the same as property, but "@<name>" in expressions
    class InstanceVariable
      include Named

      def initialize(name:, description: '')
        @name = name.to_s
        @description = description
      end
    end
      
  end
end
