# frozen_string_literal: true

require 'tmpdir'

module Punch

  class Sandbox
    def self.call
      Dir.mktmpdir([TMPRX]) do |dir|
        Dir.chdir(dir) do
          playbox = Gateways::PlayboxPort.gateway
          playbox.punch_dir(DUMMY)
          Dir.chdir(DUMMY){ yield }
        end
      end
    end

    TMPRX = 'punch'.freeze
    DUMMY = 'dummy'.freeze
  end

end


# @todo now I have Punch.sandbox so this class should be replaced in tests
# class PunchedBox
#   # Execute block inside temp punched folder
#   def self.call
#     Dir.mktmpdir([TMPRX]) do |dir|
#       Dir.chdir(dir) do
#         punched = Punch::Ports::PunchedPort.gateway
#         punched.punch_dir(DUMMY)
#         Dir.chdir(DUMMY) { yield }
#       end
#     end
#   end
# end
