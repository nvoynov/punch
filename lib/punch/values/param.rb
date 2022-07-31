# frozen_string_literal: true
require 'clean'
include Clean
include Comparable

module Punch
  module Values

    # Param Value represents a method parameter
    #
    # @examples
    #   param = Param.new('param')
    #   param = Param.new('param = nil')
    #   param = Param.new('param:')
    #   param = Param.new('param:type')
    #   param = Param.new('param:type nil')
    #
    Param = Value.punch(:raw, :name, :keyword, :type, :tail) do
      def initialize(raw)
        name, *tail = raw.split(?\s)
        kwar = name.include?(?:)
        name, type = name.split(?:)
        super(raw: raw, name: name, keyword: kwar, type: type, tail: tail.join(?\s))
      end

      def <=>(another)
        return nil unless self.class == another.class

        return  1 if keyword? && another.positional?
        return -1 if positional? && another.keyword?

        if positional? && another.positional?
          return  1 if tail? && !another.tail?
          return -1 if another.tail? && !tail?
        end

        if keyword? && another.keyword?
          return  1 if tail? && !another.tail?
          return -1 if another.tail? && !tail?
        end

        0
      end

      def keyword?
        @keyword
      end

      def positional?
        !keyword?
      end

      def typed?
        !!@type
      end

      def tail?
        !@tail.empty?
      end

      def type_s
        typed? ? type.capitalize : "Object"
      end

      def define_s
        [name].tap{|str|
          str << ':' if keyword?
          str << " #{tail}" if tail?
        }.join
      end

      def assign_s
        ["@#{name} = "].tap{|str|
          str << (typed? ? "Mustbe#{type_s}.(#{name})" : "#{name}")
        }.join
      end

      def argument_s
        keyword? ? "#{name}: @#{name}" : "@#{name}"
      end

      def reader_s
        <<~EOF
          # @param #{name} [#{type_s}]
          attr_reader :#{name}
        EOF
      end
    end

  end
end
