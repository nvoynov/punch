require_relative '../entities'

module CleanArchitecture
  module Builders

    # Build test
    class BuildTest
      # @param kmodule [Entities::KModule]
      def self.call(kmodule, domain)
        kmethods = kmodule.kmethods
          .map{ Entities::KMethod.new(name: "test_#{it.name}") }

        superklass = 'Minitest::Test'
        test_name  = "test_#{kmodule.name}"
        case kmodule.parent
        when domain.interactors, domain.entities
          Entities::Klass.new(name: test_name, superklass:).add(*kmethods)
        when domain.ports
          Entities::KModule.new(name: "shared_#{test_name}").add(*kmethods)
        else
          fail "Unknown test subject" 
        end
      end
    end

  end
end
