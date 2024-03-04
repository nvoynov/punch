require 'psych'
require_relative 'basics'

module Punch
  def root
    dir = File.dirname(__dir__)
    File.expand_path("..", dir)
  end

  def assets
    File.join(root, 'lib', 'assets')
  end

  def starter
    File.join(assets, 'starter')
  end

  def samples
    File.join(assets, 'samples')
  end

  def domain
    File.join(assets, 'domain')
  end

  def basics
    File.join(root, 'lib', 'punch', 'basics')
  end

  class Config < Data.define(:lib, :test, :domain, :sentries, :entities, :services, :plugins)
    def self.read
      return new.tap{|o| File.write(CONF, Psych.dump(o.to_h.transform_keys(&:to_s)))} \
        unless File.exist?(CONF)
      new(**Psych.load(File.read(CONF)).transform_keys(&:to_sym))
    rescue => e
      puts 'Punch: reading config error; default config used', e.full_message
      new
    end

    def initialize(
      lib: 'lib', test: 'test', domain: '',
      sentries: 'sentries',
      entities: 'entities',
      services: 'services',
      plugins: 'plugins'
    )
      super
    end
  end

  CONF = 'punch.yml'.freeze

  Config.extend(Plugin)
  ConfigHolder = Config.plugin

end
