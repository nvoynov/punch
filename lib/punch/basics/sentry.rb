# frozen_string_literal: true

module Punch
  # Factory module for guarding method arguments
  #
  # @example
  #
  #   ShortString = Sentry.new(:str, "must be String[3..100]"
  #   ) {|v| v.is_a?(String) && v.size.between?(3,100)}
  #
  #   ShortString.(str)         => "str"
  #   ShortString.(nil)         => ArgumentError ":str must be String[3..100]"
  #   ShortString.error(nil)    => ":str must be String[3..100]"
  #   ShortString.error!(nil)   => ArgumentError":str must be String[3..100]"
  #   ShortString.(nil, :name)  => ArgumentError ":name must be String[3..100]"
  #   ShortString.(nil, 'John Doe', 'Ups!') => ArgumentError ":John Doe Ups!"
  #
  module Sentry

    # creates a new Sentry
    # @param key [Symbol|String] key for error message
    # @param msg [String] error message
    # @param blk [&block] validation block that should return boolen
    # @return [Sentry] based on key, msg, and validation block
    def self.new(key, msg, &blk)
      # origin ;)
      argerror = ->(val, msg, cnd) {
        fail ArgumentError, msg unless cnd
        val
      }
      Module.new do
        include Sentry
        extend self

        @key = argerror.(key, ":key must be Symbol|String",
          key.is_a?(String) || key.is_a?(Symbol))
        @msg = argerror.(msg, ":msg must be String", msg.is_a?(String))
        @blk = argerror.(blk, "&blk must be provided", block_given?)
      end
    end

    # returns error message for invalid :val
    # @param val [Object] value to be validated
    # @param key [Symbol|String] key for error message
    # @param msg [String] optional error message
    # @return [String] error message for invalid :val or nil when :val is valid
    def error(val, key = @key, msg = @msg)
      ":#{key} #{msg}" unless @blk.(val)
    end

    # guards :val
    # @todo @see Yard!
    # @param val [Object] value to be returned if it valid
    # @param key [Symbol|String] key for error message
    # @param msg [String] optional error message
    # @return [Object] valid :val or raieses ArgumentError when invalid
    def error!(val, key = @key, msg = @msg)
      return val if @blk.(val)
      fail ArgumentError, ":#{key} #{msg}", caller[0..-1]
    end

    # @todo how do describe in Yard?
    alias :call :error!
  end

end
