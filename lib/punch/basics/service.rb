# frozen_string_literal: true

module Punch
  # Service like ServiceObject, Command, etc.
  #
  # @example just call without parameters
  #   class BoldService < Service
  #     def call
  #       42
  #     end
  #   end
  #
  # @example with parameters
  #   class PlusService < Service
  #     def initialize(a, b)
  #       @a, @b = a, b
  #     end
  #
  #     def call
  #       42
  #     end
  #   end
  #
  class Service
    Failure = Class.new(StandardError)

    class << self
      def call(*args, **kwargs, &block)
        new(*args, **kwargs, &block).call
      end

      def inherited(klass)
        klass.const_set(:Failure, Class.new(klass::Failure))
        super
      end
    end

    private_class_method :new

    def initialize(*args, **kwargs, &block)
      @args = args
      @kwargs = kwargs
      @block = block
    end

    def call
      failure "#{self.class.name}#call must be overrided"
    end

    protected

    def failure(message)
      fail Failure, message
    end

  end

end
