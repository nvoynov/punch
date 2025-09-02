require_relative '../model'
require_relative '../ports'
require 'psych'

module Punch
  module Tasks

    # Write clean config
    class WriteCleanConfig
      def self.call(config, store)
        hash = { 'domain' => config.domain }
        store.put(Punch::CLEAN_CONFIG, Psych.dump(hash))
      end
    end
  end
end
