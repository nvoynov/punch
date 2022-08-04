# frozen_string_literal: true
require 'clean'
require_relative 'param'
include Clean

module Punch
  module Values

    # Model Value stands for a concept with parameters
    Model = Value.punch(:name, :space, :parameters) do
      def initialize(*args)
        fail ArgumentError, "required at least one argument \"name\"" unless args.any?
        name = args.shift
        name, space = name.split(%r{[\/\\]})
          .then{|ary| [ary.pop, ary.join(?/)]}
        para = args.map{|arg| Param.new(arg)}
        super(name: name, space: space, parameters: para)
      end

      def define_params_str
        stable_sort(parameters).map(&:define_s).join(', ')
      end

      def assign_params_str
        stable_sort(parameters).map(&:assign_s).join(?\n) + ?\n
      end

      def method_params_str
        stable_sort(parameters).map(&:argument_s).join(', ')
      end

      def define_properties_str
        return ?\n unless parameters.any?
        keys = parameters.map{|para| ":#{para.name}"}.join(', ')
        parameters
          .map(&:reader_s)
          .push("def_properties #{keys}")
          .join(?\n) + ?\n
      end

      protected

        def stable_sort(ary)
          ary.sort_by.with_index{|x, idx| [x, idx]}
        end

    end

  end
end
