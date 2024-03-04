require_relative 'dsl'
require_relative 'model'
require_relative 'actor'

module Punch
  module DSL

    Domain = DSL.define(Models::Domain) do
      def initialize(name = '', desc = '')
        super()
        @store[:name] = name
        @store[:desc] = desc
      end

      def sentry(name, desc = '', block: '')
        @store[:sentries] ||= []
        @store[:sentries] << Models::Sentry.new(name: name, desc: desc, proc: block)
      end

      def entity(name, desc = '', &block)
        @store[:entities] ||= []
        @store[:entities] << Model.(name, desc, &block)
      end

      def service(name, desc = '', &block)
        @store[:services] ||= []
        @store[:services] << Model.(name, desc, &block)
      end

      def actor(name, desc = '', &block)
        @store[:actors] ||= []
        @store[:actors] << Actor.(name, desc, &block)
      end

      def plugin(name, desc = '')
        @store[:plugins] ||= []
        @store[:plugins] << Models::Plugin.new(name: name, desc: desc)
      end
    end

  end
end
