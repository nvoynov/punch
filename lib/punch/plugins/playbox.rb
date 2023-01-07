# frozen_string_literal: true
require_relative "../basics"
require_relative "../config"
require_relative "hashed"
require "fileutils"

module Punch

  class Playbox
    extend Plugin
    include FileUtils
    include Hashed

    Failure = Class.new(StandardError)

    def punch_home(dir)
      fail Failure, "Directory already exist!" if Dir.exist?(dir)
      furnish(dir)
    end

    def punch_home?
      File.exist?(Punch::CONFIG)
    end

    DOMAIN  = 'domain'.freeze
    BASICS  = 'basics'.freeze
    SAMPLES = '.punch'.freeze

    def home_basics?
      Dir.exist?(File.join('lib', BASICS))
    end

    # copies punch/basic sources into home
    #   lib/basics/sentry.rb
    #   lib/basics/entity.rb
    #   lib/basics/service.rb
    #   lib/basics/plugin.rb
    #   lib/basics.rb
    # @return [Array<String>] with sources copied
    def punch_basics
      return if home_basics?
      basics = File.join('lib', BASICS)
      makedirs(basics)
      cp_r "#{Punch.basics}/.", basics
      sources = Dir.glob("#{basics}/*.rb")
      punchrb = sources.map{|s|
        "require_relative \"#{BASICS}/#{File.basename(s)}\""
      }.join(?\n)
      File.write("lib/#{BASICS}.rb", punchrb)
      sources << "lib/#{BASICS}.rb"
    end

    def home_samples?
      Dir.exist?(SAMPLES)
    end

    # copies punch/basic
    # @return [Array<String>] with sources copied
    def punch_samples
      return if home_samples?
      mkdir(SAMPLES)
      cp_r "#{Punch.samples}/.", SAMPLES
      Dir.glob("#{SAMPLES}/**/*")
    end

    def home_domain?
      Dir.exist?(DOMAIN)
    end

    def punch_domain
      return if home_domain?
      mkdir(DOMAIN)
      cp_r "#{Punch.domain}/.", DOMAIN
      Dir.glob("#{DOMAIN}/**/*")
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
      File.open(name, 'a') do |f|
        f.puts string
      end
    end

    # @param model [Symbol]
    # @return [Array<String>] array of two samples, where the first for source and the second for test
    def samples(model)
      payload = case model
        when :sentry;  ['sentry.rb.erb', 'test_sentry.rb.erb']
        when :entity;  ['entity.rb.erb', 'test_entity.rb.erb']
        when :service; ['service.rb.erb', 'test_service.rb.erb']
        when :plugin;  ['plugin.rb.erb', 'test_plugin.rb.erb']
        else fail ArgumentError, "Unknown model"
        end
      dir = home_samples? ? SAMPLES : Punch.samples
      payload.map{|s| File.read(File.join(dir, s))}
    end

    protected

    def punch_home!
      fail Failure, "Punch folder required!"
    end

    def furnish(dir)
      Dir.mkdir(dir)
      Dir.chdir(dir) {
        src = File.join(Punch.starter, '.')
        cp_r src, Dir.pwd
        Punch.config # just create punch.yml
        Dir.glob("#{Dir.pwd}/**/*")
      }
    end

  end

end
