# frozen_string_literal: true

require_relative "basics"

module Punch

  class Basic
    attr_reader :name
    attr_reader :desc

    def initialize(name, desc = '')
      @name = name
      @desc = desc
    end
  end

  class SentryModel < Basic
    attr_reader :block

    def initialize(name, desc = '', block: '')
      super(name, desc)
      @block = block
      @block = 'fail "UNDER CONSTRUCTION"' if @block.empty?
      @desc = "must be #{name.capitalize}" if @desc.empty?
    end
  end

  class Param < Basic
    attr_reader :sentry
    attr_reader :default

    def initialize(name, desc = '', keyword: true, default: nil, sentry: '')
      super(name, desc)
      @keyword = keyword
      @default = default
      @sentry = sentry
    end

    def sentry?
      !@sentry.empty?
    end

    def default?
      !!@default
    end

    def keyword?
      @keyword == true
    end

    def positional?
      !keyword?
    end

    def <=>(another)
      return nil unless self.class == another.class

      return  1 if keyword? && another.positional?
      return -1 if positional? && another.keyword?

      if positional? && another.positional?
        return  1 if default? && !another.default?
        return -1 if another.default? && !default?
      end

      # @todo for Ruby purpose it does not have sense
      #   to sort keywords by default value, but for
      #   readers it might have
      if keyword? && another.keyword?
        return  1 if default? && !another.default?
        return -1 if another.default? && !default?
      end

      0
    end
  end

  class Model < Basic

    def initialize(name, desc = '')
      super(name, desc)
      @params = {}
    end

    def <<(param)
      fail ArgumentError, "Param required" unless param.is_a? Param
      @params[param.name] = param
    end

    def params
      stable_sort(@params.values)
    end

    protected

      def stable_sort(ary)
        ary.sort_by.with_index{|x, idx| [x, idx]}
      end
  end

  # @param *args [Array<String>] strings model representation
  # @return [Model] builded from args0
  class ModelBuilder < Service
    def call
      # service user/create_order user
      name = @args.shift

      Model.new(name).tap{|model|
        @args.each{|str| model.<< para(str) }
      }
    end

    def para(str)
      match = str.match(PARAM_CAPTURE)
      name  = match[:name]
      keyword = !!match[:keyword]
      sentry  = match[:sentry]
      default = match[:default].empty? ? nil : match[:default]
      Param.new(name, keyword: keyword, default: default, sentry: sentry)
    end

    PARAM_CAPTURE = /(?<name>\w*)(?<keyword>:)?(?<sentry>\w*)?\s?(?<default>.*)?$/.freeze
  end

end
