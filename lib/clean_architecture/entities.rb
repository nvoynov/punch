require_relative 'basic'

module CleanArchitecture
  module Entities
   
    # Adopt some Generator::Syntax
    Parameter = Generator::Syntax::Parameter
    KMethod   = Generator::Syntax::KMethod
    KProperty = Generator::Syntax::KProperty
    KModule   = Generator::Syntax::KModule
    Klass     = Generator::Syntax::Klass

    Interactor = Klass
    Entity = Klass
    Port = Klass
    
    # Domain
    class Domain < KModule
      attr_reader :interactors
      attr_reader :entities
      attr_reader :ports

      def initialize(name)
        @interactors = KModule.new(name: 'Interactors',
          description: "Interactors (use cases) namespace")

        @entities = KModule.new(name: 'Entities',
          description: "Entities (domain models) namespace")
        
        @ports = KModule.new(name: 'Ports',
          description: "Ports (gateways) namespace")

        super(name:, description: "#{name.capitalize} as Clean Architecture Domain")
        add(@interactors)
        add(@entities)
        add(@ports)
      end      
    end

  end
end
