# frozen_string_literal: true

module Punch
  # Plugin mixin serves for dependency injection
  #
  # @example
  #   class Storage
  #     extend Plugin
  #     def call
  #     end
  #   end
  #
  #   StoragePlug = Storage.plugin
  #
  #   class SequelStorage < Storage
  #   end
  #
  #   StoragePort.plugin = SequelStorage
  #
  #   require 'forwardable'
  #   class Service
  #     extend Forwardable
  #     def_delegator :StoragePlug, :object, :storage
  #     def call
  #       storage.call
  #     end
  #   end
  module Plugin

    def plugin
      klass = self
      Module.new {
        extend Holder;
        plugin klass
      }
    end

    module Holder
      def plugin(klass)
        @klass = klass
        @object = nil
      end

      def object
        fail "unknown @klass" unless @klass
        @object ||= @klass.new
      end

      def object=(o)
        fail ArgumentError.new("required an instance of #{@klass}"
        ) unless o.is_a?(@klass)
        @object = o
      end
    end
  end
end
