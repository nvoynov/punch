module Generator
  module Syntax

    # Value interface
    module Value
      # @return [Object]
      attr_reader :value
      # @return [String] sprintf format
      attr_reader :format
    end
      
  end
end
