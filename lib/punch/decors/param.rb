require_relative 'decor'

module Punch
  module Decors

    class Param < Decor

      def sentry
        return '' unless sentry?
        super == super.upcase ? super : sanitize(super).capitalize
      end

      def regular
        name + (default? ? " = #{default}" : '')
      end

      def keyword
        name + ?: + (default? ? " #{default}" : '')
      end

      # @return [String] Yard param comment
      def yardoc
        "# @param #{name} [Object] #{description}"
      end

      # @return [String] Yard property macro
      def yarpro
        <<~EOF.strip
          # !attribute [r] #{name}
          #   @return [Object] #{description}
        EOF
      end

      def guard
        return '' unless sentry?
        "#{name} = Mustbe#{sentry}.(#{name}, :#{name})"
      end

      protected

      def description
         [sentry, desc].reject(&:empty?).join(', ')
      end
    end

  end
end
