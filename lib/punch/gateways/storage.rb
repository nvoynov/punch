# frozen_string_literal: true
require 'clean'

module Punch
  module Gateways

    # This gateway stands for Punch assets
    # @todo Failure = Class.new(StandardError) improve Clean::Gateway by adding
    class Storage < Clean::Gateway

      # @param model [Decor] model to punch
      # @return [Array<String>] templates to render
      def templates(model)
        loc = File.join(Punch.assets, 'erb')
        erb = case model.klass
          when :sentry
            ['sentry.rb.erb', 'test_sentry.rb.erb']
          when :entity
            ['entity.rb.erb', 'test_entity.rb.erb']
          when :service
            ['service.rb.erb', 'test_service.rb.erb']
          else
            fail "Unreachable code"
          end

        erb.map{|tt| File.read(File.join(loc, tt))}
      end
    end

  end
end
