# frozen_string_literal: true

require 'psych'

module Punch
  extend self

  class Config; end

  def config
    @config ||= begin
      return load if File.exist?(CONF)
      save(Config.new)
    end
  end

  class Config
    attr_reader :lib
    attr_reader :test
    attr_reader :sentries
    attr_reader :entities
    attr_reader :services

    def initialize(
      lib: 'lib', test: 'test',
      sentries: 'sentries',
      entities: 'entities',
      services: 'services'
    )
      @lib = lib
      @test = test
      @sentries = sentries
      @entities = entities
      @services = services
    end

    # @todo clear punch.yml file
    # def to_h
    #   {}
    # end
  end

  protected
    CONF = 'punch.yml'.freeze

    def load
      Psych.load_file(CONF)
    end

    def save(conf)
      File.open(CONF, 'w') {|f| f.write(Psych.dump(conf))}
      conf
    end
end
