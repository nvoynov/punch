require_relative 'param'
require_relative 'model'

module Punch

  # Build Model from Array<String>
  # @example
  #
  #   BuildModel.('create', 'user_id', 'user_name:string 42')
  #
  module BuildModel
    extend self
    include Punch::Models

    def call(*args)
      name, *params = args
      para = params.map{|s|
        kwar = s.match(PARSER).named_captures
          .transform_keys(&:to_sym)
          .reject{ |_, v| v == '' }
        Param.new(**kwar)
      }
      Model.new(name: name, params: para)
    end

    alias :build :call

    PARSER = /(?<name>\w*)(:?(?<sentry>\w*))?(\s?(?<default>.*))?$/.freeze
  end
end
