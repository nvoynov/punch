require_relative '../../test_helper'
require_relative '../dummy'

class TestPunchModel < Minitest::Test
  class Subject < Punch::Services::PunchModel
    public_class_method :new
  end

  def service
    Services::PunchModel
  end

  def test_filepaths
    m = Dummy.models.first
    s = Subject.new(m, :service, 'context')
    assert_equal "lib/context/#{m.name}.rb", s.srcrb
    assert_equal "lib/context.rb", s.reqrb
    assert_equal "test/context/test_#{m.name}.rb", s.tstrb

    m = m.with(name: 'user create')
    s = Subject.new(m, :service, 'context')
    assert_equal "lib/context/user_create.rb", s.srcrb
    assert_equal "lib/context.rb", s.reqrb
    assert_equal "test/context/test_user_create.rb", s.tstrb
  end

  def test_dry_run
    Sandbox.() {
      Dummy.models.each{|m|
        service.(m, :entity, 'models')
      }
    }
  end

  def test_call
    model = Dummy.models.find{|e| e.params.size > 0}
    Sandbox.() {
      log = service.(model, :entity, 'models')
      assert_equal 7, log.size # plus folders
      log = service.(model, :entity, 'models')
      assert_equal 5, log.size # plus backup

      log = service.(model, :service, 'services')
      assert_equal 5, log.size
      log = service.(model, :service, 'services')
      assert_equal 5, log.size
    }
  end
end
