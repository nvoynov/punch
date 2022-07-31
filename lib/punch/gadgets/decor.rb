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
      sanitize(super)
    end

    # @return [String] ruby const of Model.name
    def const
      return sentry_name if@klass == :sentry
      constanize(name)
    end

    def space_config
      @space_config ||= begin
        Punch.config.then {|cfg|
          case klass
          when :sentry then cfg.sentries
          when :entity then cfg.entities
          when :service then cfg.services
          else fail "unknown model klass"
          end
        }
      end
    end

    def relative_path
      space_config
        .then{|str| space.empty? ? str : "#{str}/#{space}"}
        .then{|str| File.join(str.split(PATH_SPLITTER))}
    end

    def namespace
      relative_path
        .split(PATH_SPLITTER)
        .map(&:capitalize)
        .join('::')
    end

    # @return [String] source filename
    # @example
    #   model = Model.new(*%w(create_user para1:type1 para2:type2 para3))
    #   space = 'Punch::Services'
    #   Decor.new(model, space).source # => 'lib/punch/services/create_user.rb'
    def source_file
      File.join(Punch.config.lib, relative_path, name + '.rb')
    end

    # return [String] name of require file
    def require_file
      relative_path
        .split(PATH_SPLITTER)
        .unshift(Punch.config.lib)
        .then{|ary| ary.push("#{ary.pop}.rb")}
        .then{|ary| File.join(ary)}
    end

    # @return [String] require string 'require_relative services/this_service'
    # @todo check for service users/create_user
    def require_string
      source_file
        .split(PATH_SPLITTER)
        .then{|ary| ary.drop(ary.size - 2)}
        .then{|ary| ary.push(File.basename(ary.pop, '.*'))}
        .then{|ary| File.join(ary)}
    end

    # @return [String] test_source filename
    # @example
    #   model = Model.new(*%w(create_user para1:type1 para2:type2 para3))
    #   space = 'Punch::Services'
    #   Decor.new(model, space).test # => 'test/punch/services/create_user.rb'
    def test_file
      File.join(Punch.config.test, relative_path, "test_#{name}.rb")
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
