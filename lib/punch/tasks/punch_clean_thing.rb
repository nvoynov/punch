require_relative '../model'
require_relative '../ports'
require 'psych'

module Punch
  module Tasks

    # Punch clean thing
    class PunchCleanThing
      include CleanArchitecture
      include Generator
      
      # @param command [Array<String>]
      # @param store [Ports::Store]
      def self.call(command, store)
        new(store).call(command)
      end

      def initialize(store)
        @store = store
      end

      def call(command)
        thing, name, *args = command
        fail "required clean THING" unless thing
        fail "required clean THING NAME" unless name

        config = Tasks::ReadCleanConfig.call(@store)
        domain = Builders::BuildDomain.call(config.domain)

        the_thing = 
          case thing.downcase.to_sym
          when :interactor
            params = make_params(args)
            Builders::BuildInteractor.call(name, params, domain)
          when :entity
            props = make_props(args)
            Builders::BuildEntity.call(name, props, domain)
          when :port
            meths = make_meths(args)
            Builders::BuildPort.call(name, meths, domain)
          else
            fail "Unknown thing #{thing}"
          end
          
        test = Builders::BuildTest.call(the_thing, domain) 

        thing = Generator.generate(the_thing.parent).last
        ext = File.extname(thing.filename)
        dir = File.dirname(thing.filename)
        @store
          .all(File.join('lib', dir, "*#{ext}"))
          .map{ File.basename(it, File.extname(it)) }
          .each{ the_thing.parent.require(Syntax::KModule.new(name: it)) }
        
        sources = Generator.generate(the_thing.parent)
        test = Generator.generate(test).first
        dir = File.dirname(sources.last.filename)
        test = Assembly::Source.new(File.join(dir, test.filename),
          test.content)
        sources << test

        sources.each{ @store.put(it.filename, it.content) }
      end

      protected

      def make_params(args)
        args.map{ Syntax::Parameter.new(name: it) }
      end

      def make_props(args)
        args.map{ Syntax::KProperty.new(name: it) }
      end 
      
      def make_meths(args)
        args.map{ Syntax::KMethod.new(name: it) }        
      end 
      
    end
  end
end
