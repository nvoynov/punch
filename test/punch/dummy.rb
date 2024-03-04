require_relative '../test_helper'
require 'punch/models'

module Dummy
  extend self
  include Punch::Models

  ALPHABET = ?a.upto(?z).map{ _1 }.freeze
  PHONETIC = %w[alpfa bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu].freeze

  # @return [Array<Param>] of all possible configurations
  def params
    sentries = [nil, :UUID]
    defaults = [nil, 42   ]
    document = ['', 'description']
    alpha = Array.new(ALPHABET)
    sentries.product(defaults, document).map{|sentry, default, desc|\
      Param.new(name: alpha.shift, sentry: sentry, default: default, desc: desc)
    }
  end

  # @retrun [Array<Model>] of all possible configurations
  def models
    phonetic = Array.new(PHONETIC)
    adesc  = ['', 'description']
    aparam = [[], params]
    adesc.product(aparam).map{|desc, params|
      Model.new(name: phonetic.shift, params: params, desc: desc)
    }
  end

  def sentries
    [ Sentry.new(name: 'foo'),
      Sentry.new(name: 'bar') ]
  end

  def plugins
    [ Plugin.new(name: 'store'),
      Plugin.new(name: 'broker', desc: 'Message Broker') ]
  end

end

if __FILE__ == $0
  Dummy.params
  Dummy.models
  Dummy.plugins
end
