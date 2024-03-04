require_relative 'decor'
require_relative 'param'

module Punch
  module Decors

    class Model < Decor

      def const
        name.split(?_).map(&:capitalize).join
      end

      def namespace
        [conf.domain, context].reject(&:empty?)
          .then{|a| File.join(a)}
          .split(PATH_SEPARATOR)
          .map(&:capitalize)
          .join('::')
      end

      def indentation
        ?\s * 2 * namespace.split(/::/).size
      end

      def open_namespace
        fu = proc{|memo, e| memo << "#{?\s * 2 * memo.size}module #{e}"}
        namespace.split(/::/).inject([], &fu).join(?\n)
      end

      def close_namespace
        fu = proc{|memo, e| memo << "#{?\s * 2 * memo.size}end" }
        namespace.split(/::/).inject([], &fu).reverse.join(?\n)
      end

      def regular_params
        # @todo this does not work with decorated stuff, but why?
        # Array.new(params)
        #   .sort_by.with_index{|x, idx| [x, idx]}
        #   .map(&:regular).join(', ')
        fu = proc{|arg| arg.name + (arg.default? ? "= #{arg.default}" : '')}
        __getobj__.params
          .sort_by.with_index{|x, idx| [x, idx]}
          .map(&fu).join(', ')
      end

      def keyword_params
        params.map(&:keyword).join(', ')
      end

      def params_yardoc
        params.map(&:yardoc).join(?\n)
      end

      def params_yarpro
        params.map(&:yarpro).join(?\n)
      end

      def params_guard
        params.map(&:guard).reject(&:empty?).join(?\n)
      end

      def test_helper
        '../' * namespace.split(/::/).size + 'test_helper'
      end

      def params
        super.map{|e| Param.new(e) }
      end

      PATH_SEPARATOR = %r{[\\\/]}.freeze

    end

  end
end
