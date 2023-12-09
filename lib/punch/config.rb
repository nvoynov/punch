# frozen_string_literal: true

require "psych"

module Punch

  class << self

    def config
      conf = Config.new('lib', 'test', '', 'sentries', 'entities', 'services', 'plugins')
      conf.freeze
      text = Psych.dump(conf)
      head = text.lines.first
      body = text.lines.drop(1).join
      unless File.exist?(CONFIG)
        File.write(CONFIG, body)
        return conf
      end
      body = File.read(CONFIG)
      obj = Psych.load([head, body].join, permitted_classes: [Config, Symbol], freeze: true)
      obj.is_a?(Config) ? obj : conf # test for faulty load result
    end

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
  end

  Config = Struct.new(:lib, :test, :domain, :sentries, :entities, :services, :plugins)
  CONFIG = 'punch.yml'.freeze
end
