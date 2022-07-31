# frozen_string_literal: true

require_relative 'service'
include Punch::Values

module Punch
  module Services

    MustbeModelOrAry = Sentry.new(:model, 'must be either Model or Array[Model]'
    ) do |v|
      v.respond_to?(:model) || (
        v.is_a?(Array) && !v.empty? && v.any?{|i| i.respond_to?(:model)}
      )
    end

    class PunchSentries < Service
      # @param model [Model|Array<Model>]
      def initialize(model:)
        playbox.pwd_punched!
        @models = MustbeModelOrAry.(model)
        @models = [@models] unless @models.is_a?(Array)
        @templates = storage.templates(@models.first)
      end

      # @return [Array] filenames of punched sentries and tests
      # @todo rewrite sentry that arlready exists in sentries.rb
      def call
        sentries = playbox.read_sentries_source.lines
        tests = {}
        @models.each do |model|
          rendered = @templates.map{|erb| ErbGen.(erb, model)}
          sentries.insert(-2, rendered.first)
          sentries.insert(-2, ?\n)
          tests[model] = rendered.last
        end
        playbox.punch_sentries(sentries.join, tests)
      end
    end

  end
end
