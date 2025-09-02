require_relative '../../basic'
require_relative '../model'
require_relative '../ports'
require 'psych'

module Punch
  module Tasks

    # Punch clean domain
    class PunchCleanDomain
      include CleanArchitecture
      include Generator
      
      # @param name [String]
      # @param store [Ports::Store]
      def self.call(name, store)
        new(store).call(name)
      end

      def initialize(store)
        @store = store
      end

      def call(name)
        domain_name = name.sanitize.underscore.downcase
        config = Model::CleanDomainConfig.new(domain_name)
        Tasks::WriteCleanConfig.call(config, @store)
        domain = Builders::BuildDomain.call(domain_name)
        Generator.generate(domain)
          .map{ @store.put(it.filename, it.content) }
      end
      
    end
  end
end
