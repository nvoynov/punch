require_relative '../../test_helper'
require_relative '../dummy'
include Punch::Services

class TestBuildReport < Minitest::Test

  def test_dry_run
    Sandbox.() {
      Dummy.models.each{|m|
        PunchService.(m)
        PunchEntity.(m)
      }
      BuildReport.()
    }
  end
end
