require_relative 'named'

module Generator
  module Syntax

    # Klass property
    class KProperty
      include Named

      # @return [Class]
      attr_reader :type

      def initialize(name:, type: Object, description: '')
        @name = name.to_s
        @type = type
        @description = description
      end
    end
      
  end
end
