# frozen_string_literal: true
require_relative "playbox"

module Punch

  # This gateway is used for preview command.
  # It prints files content insted of writing
  # It still return right log of files
  class Preview < Playbox

    def write(name, string)
      log = []

      if File.exist?(name)
        return [name + '!'] if updated?(name)
        backup = name + '~'
        log << backup
      end

      dir = File.dirname(name)
      unless Dir.exist?(dir)
        # mkpath dir
        log << dir
      end

      preview = <<~EOF
        \n>> create a new source #{name}
        #{excerpt(string) + string}
      EOF
      puts preview
      log << name
    end

    def append(name, string)
      preview = <<~EOF
        \n>> append content #{name}
        #{string}
      EOF
      puts preview
    end

  end
end
