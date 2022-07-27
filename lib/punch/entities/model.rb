# frozen_string_literal: true
require_relative '../sentries'

module Punch
  module Entities

    class Param; end
    class Model; end

    MustbeModel = Sentry.new(:model, 'must be Model'
    ) { |v| v.is_a?(Model) }

    # Model for genetrating source code files
    # @example
    #   model = Model.new(%w(services/create_user para1 para2: para3:string))
    #   model.name       # => 'services/create_user'
    #   model.base_name  # => 'create_user'
    #   model.namespace  # => 'services'
    #   model.params[0].kwarg?  # => false
    #   model.params[0].type    # => ''
    #   model.params[1].kwarg?  # => true
    #   model.params[1].type    # => ''
    #   model.params[2].kwarg?  # => true
    #   model.params[2].type    # => 'string'
    #
    class Model
      attr_reader :name
      attr_reader :params
      attr_reader :base_name
      attr_reader :namespace

      def initialize(*args)
        fail "New model with empty argments!" if args.empty?
        @name, *para = MustbeStringAry.(args)
        @params = para.map{|str| Param.new(str)}
        @base_name, @namespace = get_base_space(@name)
      end

      protected

        def get_base_space(name)
          rex = %r{[\/\\]}
          base_name = name.split(rex).last
          namespace = name.split(rex).tap{|n| n.pop}.join(?/)
          [base_name, namespace]
        end

    end

    class Param
      attr_reader :name
      attr_reader :type

      def initialize(str)
        @name, @type = str.split(?:)
        @kwarg = str.include?(?:)
      end

      def kwarg?
        @kwarg
      end

      def typed?
        !!@type
      end
    end

  end
end
