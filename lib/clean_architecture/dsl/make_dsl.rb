require_relative '../builders'

module CleanArchitecture

  # DSL namespace
  module DSL

    # Make DSL mixin
    module MakeDSL
      # @return [Object] built by DSL 
      def model
        fail "#{self.class}##{__method__} must be overridden"
      end
      
      def self.included(other)
        other.extend(ClassMethods)
      end

      module ClassMethods
        def make(*args, **kwargs, &block)
          o = new(*args, **kwargs)
          o.instance_eval(&block) if block_given?
          o.model
        end
      end
    end
    
  end
end
