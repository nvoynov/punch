require_relative 'tree_node'

module Generator
  module Syntax

    # KModule
    # TODO: too much pp noise because of items duplicates real things
    class KModule
      include TreeNode
      include Named

      # @return [Array<KModule>]
      attr_reader :required
      # @return [Array<KProperty>]
      attr_reader :kproperties
      # @return [Array<KMethods>]
      attr_reader :kmethods
      # @return [Array<KModule>]
      attr_reader :kmodules

      def initialize(name:, description: name.capitalize)
        @name = name.to_s
        @description = description
        @required = []
        @kproperties = []
        @kmethods = []
        @kmodules = []
      end

      def require(kmodule)
        @required << kmodule
      end

      def add(*items)
        items.each do |item|
          case item
          when KProperty
            @kproperties << item
          when KMethod
            @kmethods << item
          when KModule
            @kmodules << item
            item.parent = self
          else
            fail "Unknown module member #{item}"
          end
        end
        self
      end

      def each(&block)
        yield(self)
        (@kproperties + @kmethods + @kmodules).each{
          it.is_a?(TreeNode) ? it.each(&block) : yield(it)
        }
      end
    end
      
  end
end
