require_relative '../../test_helper'
include Punch::Gateways

describe Playbox do

  let(:playbox) { Playbox.new }

  describe '#punch(dir)' do
    let(:home) { "home" }
    let(:file) { "file" }

    it 'must fail when alredy exists' do
      FileBox.() do
        Dir.mkdir(home)
        assert_raises(Punch::Error) { playbox.punch_dir(home) }
      end
    end

    it 'must punch' do
      FileBox.() do
        playbox.punch_dir(home)
        loc = File.join(Punch.assets, 'init')
        src = Dir.chdir(loc) { Dir.glob('**/*') }
        Dir.chdir(home) { src.each{|f| assert File.exist?(f) } }
      end
    end
  end

  describe '#clone_clean_sources' do
    it 'must fail unless playbox' do
      FileBox.() { assert_raises(Punch::Error) {playbox.clone_clean_sources}}
    end

    it 'must create home' do
      Sandbox.() do
        playbox.clone_clean_sources

        loc = File.join(Clean.root, 'lib')
        src = Dir.chdir(loc) { Dir.glob('**/*') }
        src.each{|f| assert File.exist?(File.join('lib', f))}

        loc = File.join(Clean.root, 'test', 'clean')
        src = Dir.chdir(loc) { Dir.glob('**/*') }
        src.each{|f| assert File.exist?(File.join('test', 'clean', f))}
      end
    end
  end

  describe '#sentries_source_file' do
    it 'must return source file' do
      # default config
      cfg = Punch::Config.new(lib: 'lib', sentries: 'sentries')
      Punch.stub(:config, cfg) do
        assert_equal 'lib/sentries.rb', playbox.sentries_source_file
      end
      # custom config
      cfg = Punch::Config.new(lib: 'src', sentries: 'core/sentries')
      Punch.stub(:config, cfg) do
        assert_equal 'src/core/sentries.rb', playbox.sentries_source_file
      end
    end
  end

  describe '#read_sentries_source' do
    let(:dummy) { 'module Dummy; end'}

    it 'must read sentries file when exist' do
      Sandbox.() do
        File.write(playbox.sentries_source_file, dummy)
        assert_equal dummy, playbox.read_sentries_source
      end
    end

    let(:default) {
      <<~EOF
        module %s

        end
      EOF
    }

    it 'must provide default unless exist' do
      Sandbox.() do
        body = default % Punch::Decor.new('sentry dummy').namespace
        assert_equal body, playbox.read_sentries_source
      end

      Sandbox.() do
        cfg = Punch::Config.new(lib: 'src', sentries: 'core/sentries')
        Punch.stub(:config, cfg) do
          body = default % Punch::Decor.new('sentry dummy').namespace
          assert_equal body, playbox.read_sentries_source
        end
      end
    end
  end

  describe '#punch_sentries' do
    # @todo how about to add generator to the decorator !?
    let(:sentries) {[
      Punch::Decor.new('sentry string'),
      Punch::Decor.new('sentry integer'),
    ]}
    let(:srct) { '%s = Sentry.new(:key, "msg")' }
    let(:tstt) { 'describe %s' }
    it 'must punch sentries' do
      Sandbox.() do
        source = sentries.map(&:const).map{|s| srct % s}.join(?\n)
        tests = sentries.map{|sentry| [sentry, tstt % sentry.const]}

        log = playbox.punch_sentries(source, tests)
        assert_equal 3, log.size
        log.each{|filename| assert File.exist?(filename)}
        # all files are exist and the method should do backup copies
        log = playbox.punch_sentries(source, tests)
        assert_equal 6, log.size
        assert_equal 3, log.select{|filename| filename =~ /~$/}.size
        log.each{|filename| assert File.exist?(filename)}
      end
    end
  end

  describe '#read_require_file' do
    let(:service) { Punch::Decor.new('service service') }
    let(:entity)  { Punch::Decor.new('entity entity') }

    it 'must return content' do
      Sandbox.() do
        body = playbox.read_require_file(service)
        assert_equal '', body

        dummy = "require_relative #{service.source_file}"
        playbox.write(service.require_file, dummy)
        body = playbox.read_require_file(service)
        assert_equal dummy, body
      end
    end
  end

  describe '#punch' do
    let(:service) { Punch::Decor.new('service service') }
    let(:content) { "require_relative 'services/basic'" }
    it 'must write source and test and modify require file' do
      Sandbox.() do
        playbox.write(service.require_file, content)
        log = playbox.punch(service, 'dummy source', 'dummy test')
        assert_equal 4, log.size # code, file, require~, require
      end
    end
  end


end
