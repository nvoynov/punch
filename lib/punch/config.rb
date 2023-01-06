# frozen_string_literal: true

require "psych"

module Punch

  class << self

    def config
      return Psych.load_file(CONFIG).freeze if File.exist?(CONFIG)
      conf = Config.new('lib', 'test', 'sentries', 'entities', 'services')
      File.write(CONFIG, Psych.dump(conf))
      conf
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

  Config = Struct.new(:lib, :test, :sentries, :entities, :services)
  CONFIG = 'punch.yml'.freeze
end
