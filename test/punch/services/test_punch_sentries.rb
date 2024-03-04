require_relative '../../test_helper'
require_relative '../dummy'

# module Punch
#   module Services
#     public :PunchSentries
#   end
# end

class TestPunchSentries < Minitest::Test
  def subject
    Services::PunchSentries
  end

  def test_dry_run
    Sandbox.() {
      log = subject.(Dummy.sentries)
      assert_equal 3, log.size

      log = subject.(Dummy.sentries)
      assert_empty log # no changes

      payload = Dummy.sentries.push( Models::Sentry.new(name: 'SPEC') )
      log = subject.(payload)
      assert_equal 2, log.size # new sentry and new test
    }
  end
end
