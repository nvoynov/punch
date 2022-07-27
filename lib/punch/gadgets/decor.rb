# frozen_string_literal: true

require 'clean/sentry'
require 'delegate'
require_relative '../sentries'

module Punch

  MustbeKlass = Clean::Sentry.new(:klass,
    'must be "service" | "entity" | "sentry"'
  ) {|v| [:sentry, :service, :entity].include?(v.to_sym)}

  # Model decorator
  class Decor < SimpleDelegator
    attr_reader :klass
    attr_reader :model

    # service create_user para1 para2: para3:string
    # @param object[String|Array<String>]
    def initialize(object)
      MustbeStringOrAry.(object, :object)
      command = case object
      when String
        object.split ?\s
      when Array
        object
      else
        fail "Unreachable code"
      end
      klass = command.shift
      @klass = MustbeKlass.(klass.to_sym)
      @model = Model.new(*command)
      super(@model)
    end

    def name
      sanitize(super).split(PATH_SPLITTER).last
    end

    # @return [String] ruby const of Model.name
    def const
      return sentry_name if@klass == :sentry
      constanize(name)
    end

    def space
      @space ||= begin
        Punch.config.then do |cfg|
          case klass
          when :sentry then cfg.sentries
          when :entity then cfg.entities
          when :service then cfg.services
          else fail "unknown model klass"
          end
        end
      end
    end

    def namespace
      "#{space}/#{@model.name}"
        .split(PATH_SPLITTER).tap(&:pop)
        .map(&:capitalize)
        .join('::')
    end

    # @return [String] source filename
    # @example
    #   model = Model.new(*%w(create_user para1:type1 para2:type2 para3))
    #   space = 'Punch::Services'
    #   Decor.new(model, space).source # => 'lib/punch/services/create_user.rb'
    def source_file
      "#{space}/#{@model.name}.rb"
        .split(PATH_SPLITTER)
        .unshift(Punch.config.lib)
        .then{|ary| File.join(ary)}
    end

    # return [String] name of require file
    def require_file
      "#{space}/#{@model.name}"
        .split(PATH_SPLITTER).tap(&:pop)
        .unshift(Punch.config.lib)
        .then{|ary| ary.push("#{ary.pop}.rb")}
        .then{|ary| File.join(ary)}
    end

    # @return [String] require string 'require_relative services/this_service'
    # @todo check for service users/create_user
    def require_string
      "#{space}/#{@model.name}"
        .split(PATH_SPLITTER)
        .then{|ary| ary.drop(ary.size - 2)}
        .then{|ary| File.join(ary)}
    end

    # @return [String] test_source filename
    # @example
    #   model = Model.new(*%w(create_user para1:type1 para2:type2 para3))
    #   space = 'Punch::Services'
    #   Decor.new(model, space).test # => 'test/punch/services/create_user.rb'
    def test_file
      "#{space}/#{@model.name}.rb"
        .split(PATH_SPLITTER)
        .unshift(Punch.config.test)
        .then{|ary| ary.push("test_#{ary.pop}")}
        .then{|ary| File.join(ary)}
    end

    protected

      def sanitize(str)
        str.downcase.strip.gsub(/\s{1,}/, '_')
      end

      def constanize(str)
        sanitize(str).split(?_).map(&:capitalize).join
      end

      PATH_SPLITTER = %r{[\\\/]}.freeze

      SENTRY_PREFIX = 'Mustbe'.freeze
      def sentry_name
        constanize("#{SENTRY_PREFIX} #{name}")
      end

  end
end
