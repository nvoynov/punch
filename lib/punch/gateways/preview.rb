# frozen_string_literal: true
require_relative 'playbox'

module Punch
  module Gateways

    # This gateway is used for preview command.
    # It prints files content insted of writing
    # It still return right log of files
    class Preview < Playbox

      # @see Playbox#write
      def write(filename, content)
        [].tap do |log|
          File.dirname(filename) # create folder unless exists
            .then{|dir| log << dir unless Dir.exist?(dir)}

          if File.exist?(filename)
            log << filename + '~'
          end

          preview = <<~EOF
            \n# #{'-' * filename.size}
            # #{filename}
            # #{'-' * filename.size}\n
            #{content}
          EOF
          puts preview
          log << filename
        end
      end

    end
  end
end
