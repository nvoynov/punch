# frozen_string_literal: true

require 'clean/sentry'
include Clean

module Punch

  MustbeString = Sentry.new(:args, 'must be String') {|v| v.is_a?(String)}

  MustbeStringAry = Sentry.new(:args, 'must be Array[String]'
  ) {|v| v.is_a?(Array) && v.any?{|i| i.is_a?(String)} }

  MustbeStringOrAry = Sentry.new(:args, 'must be String | Array[String]'
  ) { |v| v.is_a?(String) || (
          v.is_a?(Array) && v.any?{|i| i.is_a?(String)})
  }

  MustbeModelOrAry = Sentry.new(:model, 'must be either Model or Array[Model]'
  ) {|v| v.respond_to?(:model) || (
         v.is_a?(Array) && !v.empty? && v.any?{|i| i.respond_to?(:model)})
  }

end
