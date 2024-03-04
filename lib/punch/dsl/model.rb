require_relative 'dsl'

module Punch
  module DSL

    Model = DSL.define(Models::Model) do
      def initialize(name, desc = '')
        super()
        @store[:name] = name
        @store[:desc] = desc
      end

      def param(name, sentry: nil, default: nil, desc: '')
        @store[:params] ||= []
        @store[:params] << Models::Param.new(name: name, sentry: sentry, default: default, desc: desc)
      end
    end

  end
end
