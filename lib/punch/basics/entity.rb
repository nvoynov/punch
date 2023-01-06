# frozen_string_literal: true

require "securerandom"
require_relative "sentry"

module Punch

  MustbeUUID = Sentry.new(:id, 'must be UUIDv4') {|v|
    v.is_a?(String) && v =~ /\h{8}-(\h{4}-){3}\h{12}/
  }

  # Simple entity class with id
  #
  # @example
  #   class User < Entity
  #     attr_reader :login
  #     attr_reader :secret
  #     def initialize(id: nil, login:, secret:)
  #       super(id)
  #       @login = login
  #       @secret = secret
  #     end
  #   end
  #
  class Entity
    # @return [UUIDv4]
    attr_reader :id

    def initialize(id)
      @id = !!id ? MustbeUUID.(id) : SecureRandom.uuid
    end
  end

end
