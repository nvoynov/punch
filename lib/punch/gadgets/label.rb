# frozen_string_literal: true

require 'digest'

module Punch

  # @todo to stick the label or not to stick?
  # The module for sticking some metadata inside source files content
  # - Was it punched or created manually?
  # - Has it been changed after punching?
  module Label
    def label(content)
      ver = Punch::VERSION
      md5 = md5(content)
      ban = SNIPPET % [ver, md5]
      [ban, content].join
    end

    def labeled?(content)
      lines = content.lines.take(3)
      return false unless lines[0] =~ VERREGX
      return false unless lines[2] =~ MD5REGX
      true
    end

    def changed?(content)
      fail "unknown content" unless labeled?(content)
      label = content.lines.take(3)
      orign = content.lines.drop(3).join
      ver = label[0].match(VERREGX)[1]
      md5 = label[2].match(MD5REGX)[1]
      md5 != md5(orign)
    end

    def origin?(content)
      !changed?(content)
    end

    protected

    def md5(content)
      Digest::MD5.hexdigest(content)
    end

    VERREGX = %r{([\d\.]+)$}.freeze
    MD5REGX = %r{MD5 ([0-9a-f]+)$}.freeze
    SNIPPET = <<~EOF.freeze
      # This content was "punched" by Punch v%s
      # find more https://github.com/nvoynov/punch
      # MD5 %s
    EOF
  end

end
