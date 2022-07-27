require_relative '../test_helper'

describe CLI do

  # the "preview" command replaces Playbox, to it should be set here
  before do
    Gateways::PlayboxPort.gateway = Gateways::Playbox.new
  end

  it 'must provide banner' do
    assert_equal CLI::BANNER, CLI.banner
  end

  describe '#log_and_rescue' do
    let(:dummy) {
      -> {
        [].tap{|log|
          log << "source.rb"
          log << "source.rb~"
          log << "test.rb"
        }
      }
    }

    it 'must print log' do
      out, _ = capture_io { CLI.log_and_rescue { dummy.call } }
      assert_match "create source.rb", out
      assert_match "backup source.rb~", out
      assert_match "create test.rb", out
    end

    let(:error) { fail StandardError, "something went wrong" }
    it 'must resque ex' do
      out, _ = capture_io { CLI.log_and_rescue { error.call } }
      assert_match %r{something went wrong \(StandardError\)}, out
    end
  end

  describe '#create' do
    let(:dummy) { 'dummy' }

    it 'must create' do
      Sandbox.() {
        out, _ = capture_io { CLI.create(dummy) }
        map_logged_to_exist(out).each{|yes| assert yes}
      }
    end

    it 'must error' do
      Sandbox.() do
        out, _ = capture_io {
          CLI.create(dummy)
          CLI.create(dummy)
        }
        assert_match %r{already exists \(Punch::Error\)}, out
      end
    end
  end

  describe '#init' do
    it 'must init punched in pwd' do
      FileBox.() do
        out, _ = capture_io { CLI.init }
        map_logged_to_exist(out).each{|yes| assert yes}
      end
    end

    it 'must error when already punched' do
      FileBox.() do
        out, _ = capture_io { CLI.init }
        out, _ = capture_io { CLI.init }
        assert_match %r{(Punch::Error)}, out
      end
    end
  end

  describe '#clone_clean' do

    it 'must require punched pwd' do
      FileBox.() do
        out, _ = capture_io { CLI.clone('clean') }
        assert_match %r{\(Punch::Error\)}, out
      end
    end

    it 'must clone clean sources' do
      Sandbox.() do
        out, _ = capture_io { CLI.clone('clean') }
        map_logged_to_exist(out).each{|yes| assert yes}
      end
    end
  end

  describe '#punch' do
    it 'must require punched pwd' do
      FileBox.() do
        out, _ = capture_io { CLI.punch('some') }
        assert_match %r{\(Punch::Error\)}, out
      end
    end

    it 'must punch sentry' do
      Sandbox.() do
        out, _ = capture_io { CLI.punch('sentry string message') }
        map_logged_to_exist(out).each{|yes| assert yes}
      end
    end

    it 'must punch entity' do
      Sandbox.() do
        out, _ = capture_io { CLI.punch('entity user name email') }
        map_logged_to_exist(out).each{|yes| assert yes}
      end
    end

    it 'must punch service' do
      Sandbox.() do
        out, _ = capture_io { CLI.punch('service create_user name email') }
        map_logged_to_exist(out).each{|yes| assert yes}
      end
    end
    # it 'must punch gateway'
  end

  describe '#preview' do
    it 'must preview' do
      _, _ = capture_io {
        CLI.preview %w(service users/create_user name:string email:string)
      }
    end
  end
end
