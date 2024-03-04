require_relative '../models'

module Punch
  module DSL

    Models = Punch::Models

    # Basic DSL for Data class
    #
    # @example
    #
    #   Para = Data.define(:name, :type)
    #   ParaDSL = DSL.define(Para)
    #   para = ParaDSL.() {
    #     name ?a
    #     type ?b
    #   }
    #
    #   Func = Data.define(:name, :params)
    #   FuncDSL = DSL.define(Func) do
    #     def param(name, type)
    #       @store[:params] ||= []
    #       @store[:params] << Para.new(name: name, type: type)
    #     end
    #
    #     def initialize(name)
    #       super()
    #       @store[:name] = name
    #     end
    #   end
    #
    #   func = FuncDSL.(:func) {
    #     param ?a, ?b
    #     param ?b, ?c
    #   }
    #
    #   Dom = Data.define(:name, :funcs)
    #   DomDSL = DSL.define(Dom) do
    #     def initialize
    #       super
    #     end
    #
    #     def func(name, &block)
    #       @store[:funcs] ||= []
    #       @store[:funcs] << FuncDSL.(name, &block)
    #     end
    #   end
    #   dom = DomDSL.build {
    #     name :domain
    #     func :foo do
    #       param :bar, ?a
    #       param :buz, ?b
    #     end
    #   }
    class DSL
       class << self
         def define(klass, &block)
           fail "klass must be < Data" unless klass < Data
           Class.new(self) do
             @klass = klass
             @klass.members.each {|key|
               define_method(key){|arg| @store[key] = arg}
             }
             class_eval(&block) if block
             singleton_class.undef_method :define
           end
         end

         def call(*args, **kwargs, &block)
           new(*args, **kwargs)
             .tap {|o| o.instance_eval(&block) if block_given? }
             .then{|o| @klass.new(**o.instance_variable_get(:@store)) }
         end
         alias :build :call
       end

      # hide DataDSL.new
      private_class_method :new

      def initialize
        @store = {}
      end
    end

  end
end
