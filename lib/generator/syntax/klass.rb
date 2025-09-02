require_relative 'kmodule'

module Generator
  module Syntax

    # Klass
    class Klass < KModule
      # @return [Klass]
      attr_reader :superklass

      def initialize(name:, superklass: nil, description: name.capitalize)
        @superklass = superklass
        super(name:, description:)
      end
    end
      
  end
end
