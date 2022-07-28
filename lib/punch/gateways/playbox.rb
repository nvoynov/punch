# frozen_string_literal: true
require 'clean'
require 'fileutils'
require_relative '../gadgets'
include FileUtils

module Punch
  module Gateways

    # This gateway stands for working directory
    class Playbox < Clean::Gateway

      def directory_does_not_exist!(dir)
        Punch.error! "A directory \"#{dir}\" already exists" if Dir.exist?(dir)
      end

      def pwd_punched!
        Punch.error! "This directory have not \"punched\"" unless pwd_punched?
      end

      def pwd_punched?
        Dir.exist?('test') &&
        File.exist?('Gemfile') &&
        File.read('Gemfile') =~ /gem "punch"/
      end

      def punch_dir(dir)
        directory_does_not_exist!(dir)
        Dir.mkdir(dir)
        Dir.chdir(dir) { punch_pwd }
      end

      def punch_pwd
        Punch.error! "This directory already \"punched\"" if pwd_punched?
        src = File.join(Punch.assets, 'init', '.')
        FileUtils.cp_r src, Dir.pwd
        Dir.glob("#{Dir.pwd}/**/*")
      end

      def clone_clean_sources
        pwd_punched!

        src = File.join(Clean.root, 'lib', '.')
        cp_r(src, File.join(Dir.pwd, 'lib'))
        # one can get tests when 'clean' required via :git
        src = File.join(Clean.root, 'test', 'clean')
        cp_r(src, File.join(Dir.pwd, 'test'))
        # @todo return punched sources
        [].tap{|log|
          log.concat(Dir.glob('lib/**/*'))
          log.concat(Dir.glob('test/**/*'))
        }
      end

      def sentries_source_file
        Punch::Decor.new('sentry dummy').require_file
      end

      # @return [String] sentries source file body
      def read_sentries_source
        sentry = Decor.new('sentry dummy')
        filename = sentries_source_file
        unless File.exist?(filename)
          # @todo template?
          return <<~EOF
            module #{sentry.namespace}

            end
          EOF
        end
        File.read(filename)
      end

      # @param source [String] new body for sentries.rb
      # @param tests[Hash<Model: test_source>] hash with tests
      # @return [Array<String>] filenames of punched entries
      def punch_sentries(source, tests)
        filename = sentries_source_file
        [].tap do |log|
          log << write(filename, source)
          tests.each do |model, test_code|
            log << write(model.test_file, test_code)
          end
        end.flatten
      end

      # creates files based on rendered content
      # @param model [Decor] model to punch
      # @param rendered [Array<String>] rendered templates,
      #   where #first is the source, and #last is the test
      def punch(model, source_code, test_code)
        [].tap do |log|
          log << write(model.source_file, source_code)
          # include
          klass_require = read_require_file(model)
          unless klass_require.match(model.require_string)
            klass_require += "require_relative '#{model.require_string}'"
            log << write(model.require_file, klass_require)
          end
          log << write(model.test_file, test_code)
        end.flatten
      end

      def read_require_file(model)
        return '' unless File.exist?(model.require_file)
        File.read(model.require_file)
      end

      # @param filename [String]
      # @param content [String]
      # @return [Array] of created and rewritten files
      def write(filename, content)
        [].tap do |log|
          File.dirname(filename) # create folder unless exists
            .then{|dir| makedirs(dir) unless Dir.exist?(dir)}

          if File.exist?(filename)
            cp(filename, filename + '~')
            log << filename + '~'
          end

          File.write(filename, content)
          log << filename
        end
      end

    end
  end
end
