# frozen_string_literal: true

require_relative 'service'
require_relative 'punch_sentries'
include Punch::Entities

module Punch
  module Services

    # Punches commands :)
    class Punch < Service
      # @param command [*Array<String>] punch command
      def initialize(command)
        playbox.pwd_punched!
        @model = Decor.new(MustbeStringOrAry.(command))
      end

      # @return [Array<String>] created and modified files
      def call
        return PunchSentries.(model: @model) if @model.klass == :sentry
        [].tap do |log|
          log.concat(punch_sentries)
          code_source, test_source = storage.templates(@model)
            .map{|erb| ErbGen.(erb, @model)}
          log.concat playbox.punch(@model, code_source, test_source)
        end
      end

      def punch_sentries
        return [] if sentries_to_punch.empty?
        PunchSentries.(model: sentries_to_punch)
      end

      def sentries_to_punch
        # service call param param1:string param2:integer
        # => ['MustbeString', 'MustbeInteger']
        model_sentries = @model.params
          .select{|param| param.kwarg? && param.typed?}
          .map(&:type)
          .uniq
          .map{|type| Decor.new("sentry #{type}")}

        # [MustbeString, MustbeArray]
        alredy_punched_consts = playbox.read_sentries_source.lines
          .select{|line| line.match?(/Sentry.new/)}
          .map{|line| line.split(?\s).first.strip } # => MustbeString

        model_sentries
          .reject{|sentry| alredy_punched_consts.include?(sentry.const)}
      end
    end

  end
end
