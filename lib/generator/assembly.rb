module Generator

  # Assembly namespace
  module Assembly
    
    # Source file
    class Source
      # @return [String]
      attr_reader :filename
      # @return [String]
      attr_reader :content

      # @param filename [String]
      # @param content [String]
      def initialize(filename, content)
        @filename = filename
        @content = content
      end
    end  
  end
end
