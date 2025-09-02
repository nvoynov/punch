module Generator
  module Syntax

    # Tree Node mixin
    module TreeNode
      include Enumerable

      # @return [Tree]
      attr_reader :parent

      def add(item)
        fail "#{self.class}##{__method__} must be overridden"
      end
      
      def each(&block)
        yield self
      end

      def parents
        ref = self        
        [].tap{ it << ref while (ref = ref.parent) }
      end

      def root
        parent ? parent.root : self
      end
      
      protected

      def parent=(parent)
        @parent = parent
      end
    end
      
  end
end
