# frozen_string_literal: true
require "digest"

module Punch

  # Punch branded header
  module Hashed

    # @param string [String] string to create excerpt
    # @return [String] banner for string
    def excerpt(string)
      EXCERPT % Digest::MD5.hexdigest(string)
    end

    # @param string [String] string to test for havig excerpt
    # @return [Boolean] true if string contains right excerpt,
    #   false otherwise
    def excerpt?(string)
      string.lines.first =~ /^#\sMD5\s[a-f0-9]{32}$/
    end

    def correct?(string)
      return false unless excerpt?(string)
      capture = /MD5\s([a-f0-9]{32})$/
      header = string.lines.first
      origin = header.match(capture)[1]
      actual = Digest::MD5.hexdigest(
        string.lines
          .drop(EXCERPT.lines.size)
          .join
      )
      actual == origin
    end

    EXCERPT = <<~EOF.freeze
      # MD5 %s
      # see https://github.com/nvoynov/punch
    EOF
  end

end
