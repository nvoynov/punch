require_relative 'decor'

module Punch
  module Decors

    class Sentry < Decor

      def const
        PREFIX + name.split(?_).map(&:capitalize).join
      end

      def namespace
        [conf.domain, conf.sentries].reject(&:empty?)
          .then{|a| File.join(a)}
          .split(PATH_SEPARATOR)
          .map(&:capitalize)
          .join('::')
      end

      def test_helper
        '../' * namespace.split(/::/).size + 'test_helper'
      end

      PREFIX = 'Mustbe'
      PATH_SEPARATOR = %r{[\\\/]}.freeze

    end

  end
end
