require_relative '../entities'

module CleanArchitecture
  module Builders

    # Build port
    class BuildPort
      def self.call(name, kmethods, domain)
        Entities::Port.new(name:).tap do
          it.add(*kmethods)
          domain.ports.add(it)
        end
      end
    end

  end
end
