require_relative "../test_helper"

class TestSentryDecor < Minitest::Test
  def test_const
    model = SentryModel.new('dummy')
    decor = Factory.decorate(:sentry, model)
    assert_equal 'MustbeDummy', decor.const
  end
end

class TestSourceDecor < Minitest::Test

  def model(name)
    Model.new(name).tap{|m|
      m.<< Param.new('para1')
    }
  end

  def decor(klass, name)
    Factory.decorate(klass, model(name))
  end

  def test_app_config
    appconf = Punch::Config.new('app', 'test', 'sen', 'ent', 'ser')
    Punch.stub :config, appconf do
      deco = decor(:service, 'get')
      assert_equal 'app/ser/get.rb', deco.source
      assert_equal 'app/ser.rb', deco.require
      assert_equal 'ser/get', deco.require_string
      assert_equal 'test/ser/test_get.rb', deco.test
      assert_equal 'Ser', deco.namespace

      deco = decor(:service, 'user/get')
      assert_equal 'app/ser/user/get.rb', deco.source
      assert_equal 'app/ser/user.rb', deco.require
      assert_equal 'user/get', deco.require_string
      assert_equal 'test/ser/user/test_get.rb', deco.test
      assert_equal 'Ser::User', deco.namespace
    end
  end

  def test_gem_config
    gemconf = Punch::Config.new('lib/dummy', 'test', 'sen', 'ent', 'ser')
    Punch.stub :config, gemconf do
      deco = decor(:service, 'get')
      assert_equal 'lib/dummy/ser/get.rb', deco.source
      assert_equal 'lib/dummy/ser.rb', deco.require
      assert_equal 'ser/get', deco.require_string
      assert_equal 'test/ser/test_get.rb', deco.test
      assert_equal 'Ser', deco.namespace

      deco = decor(:service, 'user/get')
      assert_equal 'lib/dummy/ser/user/get.rb', deco.source
      assert_equal 'lib/dummy/ser/user.rb', deco.require
      assert_equal 'user/get', deco.require_string
      assert_equal 'test/ser/user/test_get.rb', deco.test
      assert_equal 'Ser::User', deco.namespace
    end
  end

  def test_test_helper
    deco = decor(:service, 'create_order')
    assert_equal '../../test_helper', deco.test_helper
  end

  def test_const
    deco = decor(:service, 'create_order')
    assert_equal "CreateOrder", deco.const
    deco = decor(:service, 'user/create_order')
    assert_equal "CreateOrder", deco.const
  end

  def test_properties
    model = ModelBuilder.(:dummy,
      'a', 'b:', 'c nil', 'd:integer', 'e:integer 42')
    decor = Factory.decorate(:entity, model)
    decor.properties
    decor.parameters
    decor.assignment

    model = ModelBuilder.(:dummy)
    decor = Factory.decorate(:entity, model)
    puts decor.properties
    puts decor.parameters
    puts decor.assignment
  end
end
