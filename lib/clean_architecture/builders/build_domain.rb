require_relative '../entities'

module CleanArchitecture
  module Builders

    # Build domain
    class BuildDomain
      def self.call(name)
        Entities::Domain.new(name)
      end
    end  

  end
end
