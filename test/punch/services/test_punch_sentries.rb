require_relative '../../test_helper'

describe Services::PunchSentries do

  let(:puncher) { Services::PunchSentries }

  describe '#failure' do
    it 'must fail when directore did not punched' do
      FileBox.() { assert_raises(ArgumentError) { puncher.() } }
    end

    it 'must fail for wrong arguments' do
      Sandbox.() { assert_raises(ArgumentError) { puncher.(42) } }
    end
  end

  describe '#success' do
    # @todo read parameters inside ""
    #       sentry string "description" "v.is_a?(String) && !v.empty?"
    # it must bonus from command line :)
    let(:sentry) { "sentry string message v.is_a?(String) description" }
    let(:sentries) {[
      "sentry string message v.is_a?(String) description",
      "sentry integer",
      "sentry boolean",
    ]}

    it 'must punch sentries' do
      Sandbox.() do
        log = puncher.(model: Decor.new(sentry))
        assert_equal 2, log.size # sentries.rb, test/test_string.rb
        log.each{|filename| assert File.exist?(filename)}

        models = sentries.map{|s| Decor.new(s)}
        log = puncher.(model: models)
        assert_equal 6, log.size # sentries.rb, ~, 3 tests, 1 test~
        log.each{|filename| assert File.exist?(filename)}
      end
    end
  end
end
