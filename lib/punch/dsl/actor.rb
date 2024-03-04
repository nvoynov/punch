require_relative 'dsl'
require_relative 'model'

module Punch
  module DSL

    Actor = DSL.define(Models::Actor) do
      def initialize(name, desc = '')
        super()
        @store[:name] = name
        @store[:desc] = desc
      end

      def service(name, desc = '', &block)
        @store[:services] ||= []
        @store[:services] << Model.(name, desc, &block)
      end
    end

  end
end
