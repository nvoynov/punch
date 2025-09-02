require_relative '../model'
require_relative '../ports'
require 'psych'

module Punch
  module Tasks

    # Read clean config
    # TODO: errors handling
    class ReadCleanConfig
      def self.call(store)
        data = store.get(Punch::CLEAN_CONFIG)
        hash = Psych.load(data)
        Model::CleanDomainConfig.new(hash['domain'])
      end
    end
  end
end
