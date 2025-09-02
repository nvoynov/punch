require_relative 'basic'

module Punch
  module Model

    # Clean domain configuration
    class CleanDomainConfig
      attr_reader :domain

      def initialize(domain)
        @domain = domain
      end
    end

  end
end
