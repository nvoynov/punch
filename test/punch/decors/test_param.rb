require_relative '../../test_helper'
require_relative '../dummy'

class TestParamDecor < Minitest::Test
  def subject = Decors::Param

  def test_dry_run
    methods = %i[sentry regular keyword yardoc yarpro guard]
    Dummy.params.map{|e| subject.new(e)}.each{|e|
      methods.each{|m| e.send(m) }
    }
  end
end
