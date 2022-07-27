require_relative '../../test_helper'

describe Decor do

  let(:command) { 'service create_user para1 para2: para3:string' }
  let(:invalid) { 'invalid create something' }
  let(:dummy)   { Decor.new(command) }

  let(:model) { 'service domain/user/create name' }

  # bug bug bug
  it 'should not fail' do
    cmd = "service query select: from: where: order: page_number:integer page_size:integer"
    Decor.new(cmd.split(?\s))
  end


  describe 'usage' do
    it 'must decorate :sentry' do
      config = Punch::Config.new(
        lib: 'lib', test: 'test',
        sentries: 'core/sentries',
        services: 'core/services')

      Punch.stub(:config, config) do
        command = ['sentry', 'string', 'must be String', 'v.is_a?(String)']
        decor = Decor.new(command)
        assert_equal :sentry, decor.klass
        assert_equal 'string', decor.name
        assert_equal 'Core::Sentries', decor.namespace
        assert_equal 'lib/core/sentries.rb', decor.require_file
        assert_equal 'lib/core/sentries/string.rb', decor.source_file
        assert_equal 'test/core/sentries/test_string.rb', decor.test_file

        assert_equal 2, decor.params.count
        refute decor.params.first.kwarg?
        refute decor.params.first.type
        assert_equal 'must be String', decor.params.first.name
        refute decor.params.last.kwarg?
        refute decor.params.last.type
        assert_equal 'v.is_a?(String)', decor.params.last.name
      end
    end

    it 'must decorate :service' do
      config = Punch::Config.new(
        lib: 'lib', test: 'test',
        services: 'services/core')

      Punch.stub(:config, config) do
        command = 'service create para kwpara: str:string'
        decor = Decor.new(command)
        assert_equal :service, decor.klass
        assert_equal 'create', decor.name
        assert_equal 'Services::Core', decor.namespace
        assert_equal 'lib/services/core.rb', decor.require_file
        assert_equal 'lib/services/core/create.rb', decor.source_file
        assert_equal 'test/services/core/test_create.rb', decor.test_file

        assert_equal 3, decor.params.count
        refute decor.params.first.kwarg?
        refute decor.params.first.type
        assert_equal 'para', decor.params.first.name

        assert decor.params[1].kwarg?
        refute decor.params[1].type
        assert_equal 'kwpara', decor.params[1].name

        assert decor.params.last.kwarg?
        assert decor.params.last.type
        assert_equal 'str', decor.params.last.name
        assert_equal 'string', decor.params.last.type
      end
    end

    it 'must decorate nested :service' do
      config = Punch::Config.new(
        lib: 'lib', test: 'test', services: 'services/core')

      Punch.stub(:config, config) do
        command = 'service users/create para kwpara: str:string'
        decor = Decor.new(command)
        assert_equal :service, decor.klass
        assert_equal 'create', decor.name
        assert_equal 'Services::Core::Users', decor.namespace
        assert_equal 'lib/services/core/users.rb', decor.require_file
        assert_equal 'users/create', decor.require_string
        assert_equal 'lib/services/core/users/create.rb', decor.source_file
        assert_equal 'test/services/core/users/test_create.rb', decor.test_file
      end
    end
    # it 'must decorate :entity'
    # it 'must decorate :gateway'
  end

  describe '#new' do
    it 'must fail unless klass found' do
      assert_raises(ArgumentError) { Decor.new(invalid) }
    end

    it 'must parse command' do
      assert dummy.klass
      assert dummy.model
      assert dummy.space
    end
  end

  describe '#space' do
    it 'must get it from Punch.config' do
      deco = Decor.new('service spec')
      assert_equal Punch.config.services, deco.space
      deco = Decor.new('entity spec')
      assert_equal Punch.config.entities, deco.space
      deco = Decor.new('sentry spec')
      assert_equal Punch.config.sentries, deco.space
    end
  end

  describe '#const' do
    it 'must return ruby const' do
      assert_equal 'MustbeSpec', Decor.new('sentry spec').const
      assert_equal 'MustbeOtherSpec', Decor.new('sentry other_spec').const
      assert_equal 'MustbeOtherSpec', Decor.new('sentry other_Spec').const
    end

    it 'must return ruby const 2' do
      assert_equal 'MustbeSpec', Decor.new(%w(sentry spec)).const
      assert_equal 'MustbeOtherSpec', Decor.new(%w(sentry other_spec)).const
      assert_equal 'MustbeOtherSpec', Decor.new('sentry other_Spec').const
    end
  end

  describe '#namespace' do
    it 'must return ruby const' do
      cfg = Punch.config
      assert_equal cfg.sentries.capitalize, Decor.new('sentry spec').namespace
      assert_equal cfg.entities.capitalize, Decor.new('entity spec').namespace
      assert_equal cfg.services.capitalize, Decor.new('service spec').namespace
    end
  end

  # let(:sentry) { Decor.new('sentry spec') }
  let(:service){ Decor.new('service spec') }
  let(:entity) { Decor.new('entity spec') }

  describe '#source_file' do
    it 'must return source file relative path' do
      lib = Punch.config.lib
      loc = File.join(lib, service.space, "#{service.name}.rb")
      assert_equal loc, service.source_file
      loc = File.join(lib, entity.space, "#{entity.name}.rb")
      assert_equal loc, entity.source_file
    end
  end

  describe '#test_file' do
    it 'must return test file relative path' do
      tst = Punch.config.test
      loc = File.join(tst, service.space, "test_#{service.name}.rb")
      assert_equal loc, service.test_file
      loc = File.join(tst, entity.space, "test_#{entity.name}.rb")
      assert_equal loc, entity.test_file
    end
  end

  describe '#require_file' do
    it 'must return require file relative path' do
      lib = Punch.config.lib
      loc = File.join(lib, "#{service.space}.rb")
      assert_equal loc, service.require_file
      loc = File.join(lib, "#{entity.space}.rb")
      assert_equal loc, entity.require_file
    end
  end

  describe '#require_string' do
    it 'must return require_relative' do
      assert_equal "#{service.space}/#{service.name}", service.require_string
      assert_equal "#{entity.space}/#{entity.name}", entity.require_string
    end
  end

end
