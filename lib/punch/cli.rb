require_relative 'config'
require 'fileutils'

module Punch

  # CLI
  module CLI
    include FileUtils
    extend self

    # @param args[Array<String>]
    def parse(args)
      command, *payload = args
      case command&.downcase&.to_sym
      when :help
        puts BANNER
      when :ruby
        punch_ruby(payload)
      when :clean
        punch_clean(payload)
      else
        exit_with("Punch didn't get you")
      end
    end

    protected

    def punch_ruby(args)
      arg = args.first
      exit_with('requried RUBY_CODE_DIR') unless arg
    
      dir = arg.sanitize.underscore.downcase
      Dir.mkdir(dir)
      Dir.chdir(dir) do
        source = Config.ruby_code_dir
        cp_r File.join(source, '.'), '.'
        mkdir 'lib'
      end

      ptrn = File.join(dir, '**/*')
      log = Dir.glob(ptrn, File::FNM_DOTMATCH).map{ "  #{it}" }
      puts "Punch: Ruby code directory created", log
    end
  
    def punch_clean(args)
      store = Config.store
      case args.first&.downcase&.to_sym
      when :domain
        Punch::Tasks::PunchCleanDomain.call(args[1], store)
      when :dsl
        puts "Not implemented yet"
      when :interactor, :entity, :port
        Punch::Tasks::PunchCleanThing.call(args, store)
      else
        puts "Unknown puncher #{args.first}"
      end
    end    

    def exit_with(message)
      puts message, BANNER
      exit
    end

    BANNER = <<~STR
      Punch code puncher v#{Punch::VERSION}
      see https://github.com/nvoynov/punch

      Usage:
        # punch new project folder with lib, app, README, CHANGELOG, ..
        punch ruby RUBY_PROJECT_DIRECTORY

        # punch Clean Architecture domain
        punch clean DOMAIN

        # punch Clean concept of NAME PROPERTIES|PARAMETERS|METHODS
        punch clean interactor "sign in" email password
        punch clean entity credentials email password
        punch clean port "data store" all put get
    STR

  end
end
