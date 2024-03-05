# frozen_string_literal: true
require_relative "../basics"
require_relative "../config"
require_relative "hashed"
require "fileutils"
require "forwardable"

module Punch

  class Playbox
    extend Forwardable
    def_delegator :ConfigHolder, :object, :conf
    extend Plugin
    include FileUtils
    include Hashed

    Failure = Class.new(StandardError)

    def punch_home(dir)
      fail Failure, "Directory already exist!" if Dir.exist?(dir)
      furnish(dir)
    end

    def punch_home?
      File.exist?(Punch::CONF) || File.exist?('Gemfile')
    end

    SAMPLES = '.punch/samples'.freeze
    DOMAIN  = '.punch/domain'.freeze
    PUNCH   = 'lib/punch'.freeze
    PUNCH_BASICS = 'lib/punch/basics'.freeze

    def home_basics?
      Dir.exist?(PUNCH_BASICS)
    end

    # copies punch/basic sources into home
    #   lib/punch/basics/sentry.rb
    #   lib/punch/basics/entity.rb
    #   lib/punch/basics/service.rb
    #   lib/punch/basics/plugin.rb
    #   lib/punch/basics.rb
    #   lib/punch.rb
    # @return [Array<String>] with sources copied
    def punch_basics
      return if home_basics?

      makedirs(PUNCH)
      cp_r "#{Punch.basics}/.", PUNCH_BASICS
      sources = Dir.glob("#{PUNCH_BASICS}/*.rb")
      fn = proc{|s| "require_relative \"basics/#{File.basename(s)}\"" }
      basicsrb = 'lib/punch/basics.rb'
      File.write(basicsrb, sources.map(&fn).join(?\n))
      File.write('lib/punch.rb', "require_relative \"punch/basics\"")
      location = [conf.lib, conf.domain, 'basics.rb'].reject(&:empty?)
      basicsrb = File.join(*location)
      punchrb = conf.domain.empty? ? "punch" : "../punch"
      content = <<~EOF
        require_relative '#{punchrb}'

        Sentry  = Punch::Sentry
        Plugin  = Punch::Plugin
        Service = Punch::Service
      EOF
      File.write(basicsrb, content)
      sources.push('lib/punch/basics.rb', 'lib/punch.rb', basicsrb)
    end

    def home_samples?
      Dir.exist?(SAMPLES)
    end

    # copies punch/basic
    # @return [Array<String>] with sources copied
    def punch_samples
      return if home_samples?
      makedirs(SAMPLES)
      cp_r "#{Punch.samples}/.", SAMPLES
      Dir.glob("#{SAMPLES}/**/*", File::FNM_DOTMATCH).tap(&:shift)
    end

    def home_domain?
      Dir.exist?(DOMAIN)
    end

    def punch_domain
      return if home_domain?
      makedirs(DOMAIN)
      cp_r "#{Punch.domain}/.", DOMAIN
      Dir.glob("#{DOMAIN}/**/*", File::FNM_DOTMATCH).tap(&:shift)
    end

    def exist?(filename)
      File.exist?(filename)
    end

    def read(filename)
      File.read(filename)
    end

    # Write file with leading header
    # @param name [String] filename
    # @paran string [String] content
    # @return [Array<String>] with written, backuped, and ignored files
    #   where last symbol '~' stands for backup and '!' for ignored
    def write(name, string)
      log = []

      if File.exist?(name)
        return [name + '!'] if updated?(name)
        backup = name + '~'
        cp name, backup
        log << backup
      end

      dir = File.dirname(name)
      unless Dir.exist?(dir)
        mkpath dir
        log << dir
      end

      File.write(name, excerpt(string) + string)
      log << name
    end

    # @return [Boolean] true if file content does not match MD5
    def updated?(name)
      string = open(name, 'r') {|f|
        elen = Hashed::EXCERPT.lines.size
        head = proc{|l| l << f.gets while !f.eof? || l.size == elen}
        tail = proc{|l| l << f.gets until f.eof?}
        body = [].tap(&head)
        # one punches file that written manually
        return false unless excerpt?(body.join)
        body.tap(&tail).join
      }
      !correct?(string)
    end

    def append(name, string)
      dir = File.dirname(name)
      mkpath(dir) unless Dir.exist?(dir)

      File.open(name, 'a') do |f|
        f.puts string
      end
      [name + '~']
    end

    # @param model [Symbol]
    # @return [Array<String>] array of two samples, where the first for source and the second for test
    def samples(model)
      payload = case model.to_sym
        when :sentry;  ['sentry.rb.erb', 'test_sentry.rb.erb']
        when :entity;  ['entity.rb.erb', 'test_entity.rb.erb']
        when :service; ['service.rb.erb', 'test_service.rb.erb']
        when :plugin;  ['plugin.rb.erb', 'test_plugin.rb.erb']
        else fail ArgumentError, "Unknown Model"
        end
      dir = home_samples? ? SAMPLES : Punch.samples
      payload.map{|s| File.read(File.join(dir, s))}
    end

    protected

    # def config
    #   @config ||= Punch.config
    # end

    def punch_home!
      fail Failure, "Punch folder required!"
    end

    def furnish(dir)
      Dir.mkdir(dir)
      Dir.chdir(dir) {
        src = File.join(Punch.starter, '.')
        cp_r src, Dir.pwd
        # Punch.config # just create punch.yml
        conf
        Dir.glob("#{Dir.pwd}/**/*")
      }
    end

  end

end
