require_relative '../../test_helper'

describe Decor do

  it '#new must accept known named klasses or fail' do
    assert_raises(ArgumentError) { Decor.new('sentry')  }
    assert_raises(ArgumentError) { Decor.new('entity')  }
    assert_raises(ArgumentError) { Decor.new('service') }
    assert_raises(ArgumentError) { Decor.new('invalid') }

    Decor.new('entity user')
    Decor.new('sentry string')
    Decor.new('service create')
  end

  it 'must decorate :sentry' do
    config = Punch::Config.new(
      lib: 'lib', test: 'test',
      sentries: 'sentries')

    Punch.stub(:config, config) do
      command = %w(sentry string)
      decor = Decor.new(command)
      assert_equal :sentry, decor.klass
      assert_equal 'string', decor.name
      assert_equal 'Sentries', decor.namespace
      assert_equal 'lib/sentries.rb', decor.require_file
      assert_equal 'lib/sentries/string.rb', decor.source_file
      assert_equal 'test/sentries/test_string.rb', decor.test_file
    end

    config = Punch::Config.new(
      lib: 'lib', test: 'test',
      sentries: 'core/sentries')

    Punch.stub(:config, config) do
      command = %w(sentry string)
      decor = Decor.new(command)
      assert_equal :sentry, decor.klass
      assert_equal 'string', decor.name
      assert_equal 'MustbeString', decor.const
      assert_equal 'Core::Sentries', decor.namespace
      assert_equal 'lib/core/sentries.rb', decor.require_file
      assert_equal 'lib/core/sentries/string.rb', decor.source_file
      assert_equal 'test/core/sentries/test_string.rb', decor.test_file
    end
  end

  it 'must decorate services and entities' do
    config = Punch::Config.new(
      lib: 'lib', test: 'test',
      entities: 'entities')

    Punch.stub(:config, config) do
      command = %w(entity user)
      decor = Decor.new(command)
      assert_equal :entity, decor.klass
      assert_equal 'user', decor.name
      assert_equal 'User', decor.const
      assert_equal 'Entities', decor.namespace
      assert_equal 'lib/entities/user.rb', decor.source_file
      assert_equal 'lib/entities.rb', decor.require_file
      assert_equal 'entities/user', decor.require_string
      assert_equal 'test/entities/test_user.rb', decor.test_file
    end

    config = Punch::Config.new(
      lib: 'lib', test: 'test',
      services: 'services')

    Punch.stub(:config, config) do
      command = %w(service create)
      decor = Decor.new(command)
      assert_equal :service, decor.klass
      assert_equal 'create', decor.name
      assert_equal 'Create', decor.const
      assert_equal 'Services', decor.namespace
      assert_equal 'lib/services.rb', decor.require_file
      assert_equal 'services/create', decor.require_string
      assert_equal 'lib/services/create.rb', decor.source_file
      assert_equal 'test/services/test_create.rb', decor.test_file
    end

    config = Punch::Config.new(
      lib: 'lib', test: 'test',
      services: 'core/services')

    Punch.stub(:config, config) do
      command = %w(service users/create)
      decor = Decor.new(command)
      assert_equal :service, decor.klass
      assert_equal 'create', decor.name
      assert_equal 'Create', decor.const
      assert_equal 'Core::Services::Users', decor.namespace
      assert_equal 'lib/core/services/users.rb', decor.require_file
      assert_equal 'users/create', decor.require_string
      assert_equal 'lib/core/services/users/create.rb', decor.source_file
      assert_equal 'test/core/services/users/test_create.rb', decor.test_file
    end

  end

end
