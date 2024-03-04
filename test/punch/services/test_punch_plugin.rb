require_relative '../../test_helper'
require_relative '../dummy'

class TestPunchPlugin < Minitest::Test

  def service
    Services::PunchPlugin
  end

  def test_dry_run
    Sandbox.() {
      Dummy.plugins.each{|m|
        service.(m)
      }
    }
  end

  def test_call
    model = Dummy.models.last
    Sandbox.() {
      log = service.(model)
      refute_empty log
      # pp log, Dir.glob('*.*')
      # log.each{|e| puts ?\n, ?\n, File.read(e) unless File.directory?(e) }
    }
  end
end
