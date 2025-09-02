require_relative 'kmethod'

module CleanArchitecture
  module DSL

    class Port
      include MakeDSL

      def initialize(name, description = '')
        @name = name
        @description = description
        @kmethods = []
      end

      def model
        domain = Builders::BuildDomain.call('domain')
        Builders::BuildPort.call(@name, @kmethods, domain)
      end

      def kmethod(name, description = '', &block)
        KMethod.make(name, description, &block)
          .tap{ @kmethods << it }
      end
    end
    
  end
end
