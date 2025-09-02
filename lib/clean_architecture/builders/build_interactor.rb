require_relative '../entities'

module CleanArchitecture
  module Builders

    # Build interactor
    class BuildInteractor
      def self.call(name, parameters, domain)
        Entities::Interactor.new(name:).tap do
          it.add(Entities::KMethod.new(name: 'call', parameters:))
          domain.interactors.add(it)
        end
      end
    end

  end
end
