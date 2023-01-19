require "delegate"
require_relative "model"
require_relative "config"

module Punch

  class Factory
    def self.decorate(klass, model)
      conf = Punch.config
      base = [conf.lib, conf.test, conf.domain]
      case klass.to_sym
      when :sentry
        SentryDecor.new(*base.concat([conf.sentries, model]))
      when :entity
        SourceDecor.new(*base.concat([conf.entities, model]))
      when :service
        SourceDecor.new(*base.concat([conf.services, model]))
      when :plugin
        SourceDecor.new(*base.concat([conf.plugins, model]))
      else
        fail "Unknown klass for decoration"
      end
    end
  end

  # Ruby source code decorator for Model
  class SourceDecor < SimpleDelegator

    def initialize(home, test, domain, base, model)
      @home = home
      @test = test
      @base = base
      @domain = domain
      super(model)
    end

    # @todo name from command-line can be complex users/create_order
    def name
      sanitize(super)
    end

    def const
      constanize(name.split(SEPARATOR).last)
    end

    def source
      File.join(path, name + '.rb')
    end

    def test
      name.split(SEPARATOR)
        .unshift([@test, @domain, @base].reject(&:empty?))
        .then{|ary| ary.push("test_#{ary.pop}.rb") }
        .then{|ary| File.join(ary) }
    end

    def test_helper
      level = namespace.split(/::/).size
      test_level = @test.split(SEPARATOR).size - 1
      level += test_level if test_level > 0
      "#{'../' * level}test_helper"
    end

    def require
      # it must be relative to source lib/entities/user.rb
      source.split(SEPARATOR)
        .then{|ary| ary.pop; ary }
        .then{|ary| ary.push(ary.pop + '.rb') }
        .then{|ary| File.join(ary) }
    end

    def require_string
      source.split(SEPARATOR)
        .then{|ary| ary.drop(ary.size - 2) }
        .then{|ary| ary.push(File.basename(ary.pop, '.*')) }
        .then{|ary| File.join(ary) }
    end

    # @todo see by examples, it should cut <name>.rb
    #   services/user/create_order.rb -> Services::User
    def namespace
      File.join([@domain, @base, name].reject(&:empty?))
        .split(SEPARATOR)
        .then{|ary| ary.pop; ary }
        .map{ constanize(_1) }
        .join('::')
    end

    def open_namespace
      fn = proc{|memo, item| memo << '  ' * memo.size + "module #{item}"}
      namespace.split(/::/)
        .inject([], &fn)
        .join(?\n)
    end

    def close_namespace
      fn = proc{|memo, _| memo << '  ' * memo.size + "end"}
      namespace.split(/::/)
        .inject([], &fn)
        .reverse
        .join(?\n)
    end

    def properties
      params.map{|param|
        param_type = param.sentry? ? param.sentry.capitalize : 'Object'
        <<~EOF
          # @return [#{param_type}] #{param.desc}
          attr_reader :#{param.name}
        EOF
      }.join(?\n)
    end

    def yardoc
      params.map{|param|
        param_type = param.sentry? ? param.sentry.capitalize : 'Object'
        "# @param #{param.name} [#{param_type}] #{param.desc}"
      }.push("# @return [@todo] what?").join(?\n)
    end

    def parameters
      params.map{|param|
        ary = [param.name]
        ary << ':' if param.keyword?
        ary << ' =' if param.default? && param.positional?
        ary << ?\s + param.default if param.default?
        ary.join
      }.join(', ')
    end

    def assignment
      params.map{|param|
        source = param.name
        source = "Mustbe#{constanize(param.sentry)}.(#{param.name})" if param.sentry?
        "@#{param.name} = #{source}"
      }.join(?\n)
    end

    def arguments
      fn = proc{|pa| pa.keyword? ? "#{pa.name}: @#{pa.name}" : "@#{pa.name}"}
      params.map(&fn).join(', ')
    end

    SEPARATOR = %r{[\\\/]}.freeze

    protected

    def path
      File.join([@home, @domain, @base].reject(&:empty?))
    end

    def relative_path
      File.join([@domain, @base, "#{name}.rb"].reject(&:empty?))
    end

    def sanitize(str)
      # @todo maybe Basic#name should return sanitized string?
      str = str.to_s unless str.is_a?(String)
      str.downcase.strip.gsub(/\s{1,}/, '_')
    end

    def constanize(str)
      sanitize(str).split(?_).map(&:capitalize).join
    end

  end

  class SentryDecor < SourceDecor
    def const
      # constanize("#{PREFIX}#{name}")
      PREFIX + super
    end

    def source
      path + '.rb'
    end

    PREFIX = 'Mustbe'.freeze
  end

end
