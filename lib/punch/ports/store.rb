module Punch
  module Ports

    # Store port
    module Store
      # @param pattern [String]
      # @return [Array<String>]
      def all(pattern = '**/*')
        fail "#{self.class}##{__method__} must be implemented"
      end

      # put file to store
      # @param filename [String]
      # @param content [String]
      def put(filename, content)
        fail "#{self.class}##{__method__} must be implemented"
      end

      # get file content from store
      # @param filename [String]
      # @return [String] file content
      def get(filename)
        fail "#{self.class}##{__method__} must be implemented"
      end
    end
    
  end
end
