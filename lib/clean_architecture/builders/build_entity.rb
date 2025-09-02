require_relative '../entities'

module CleanArchitecture
  module Builders

    # Build entity
    class BuildEntity
      def self.call(name, kproperties, domain)
        parameters = kproperties
          .map{ Entities::Parameter.new(name: it.name, description: it.description)}

        statements = parameters.map{
          Generator::Syntax::Assign.new(
            Generator::Syntax::InstanceVariable.new(name: it.name),
            it
          )
        }
        
        constructor = Entities::KMethod.new(
          name: 'initialize', parameters:, statements:)
        
        Entities::Entity.new(name:).tap do
          it.add(*kproperties)
          it.add(constructor)
          domain.entities.add(it)
        end
      end       
    end

  end
end
