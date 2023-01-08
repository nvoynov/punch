require_relative "../../test_helper"
include Punch::Services

describe PunchSentry do
  let(:service) { PunchSentry }

  it 'must punch fail for faulty arguments' do
    assert_raises(ArgumentError) { service.() }
  end

  let(:dummy) { SentryModel.new('dummy', block: 'v.is_a?(String)') }
  let(:extra) { SentryModel.new('extra', block: 'v.is_a?(String)') }

  it 'must punch sentries.rb and test/test_dummy.rb' do
    Sandbox.() {
      refute File.exist?('lib/sentries.rb')
      refute File.exist?('test/sentries/test_dummy.rb')
      log = service.(dummy)
      sample = ["lib/sentries.rb", "test/sentries/test_dummy.rb"]
      assert_equal sample, log
      assert File.exist?('lib/sentries.rb')
      assert File.exist?('test/sentries/test_dummy.rb')

      log = service.(dummy)
      assert_equal [], log # the sentry that already exist
    }
  end

  it 'must punch few sentries' do
    Sandbox.() {
      log = service.(dummy, extra)
      sample = [    "lib/sentries.rb",
        "test/sentries/test_dummy.rb",
        "test/sentries/test_extra.rb"]
      assert_equal sample, log
      sample.each{|s| assert File.exist?(s)}
      # puts File.read('lib/sentries.rb')
    }
  end

  it 'must punch nothing for declared sentries' do
    Sandbox.() {
      log = service.(dummy)
      log = service.(dummy)
      assert_equal [], log
    }
  end
end

class PunchSentry
  public_class_method :new
  public :storage, :punch, :render, :declared?, :declared
  attr_accessor :source, :test
end

class TestPunchSentry < Minitest::Test
  def service
    PunchSentry.new.tap{|s|
      source, test = s.storage.samples(:sentry)
      s.source = source
      s.test = test
    }
  end

  def test_declared
    Sandbox.() {
      assert_equal ['MustbeString'], service.declared
      assert service.declared?('MustbeString')
      refute service.declared?('MustbeFaulty')
    }

    Sandbox.() {
      fewsentries = <<~EOF
        MustbeInteger = Sentry.new(
        MustbeAnother = Sentry.new(
      EOF
      Dir.mkdir('lib') unless Dir.exist?('lib')
      File.write('lib/sentries.rb', fewsentries)

      declared = service.declared
      assert_equal %w(MustbeInteger MustbeAnother), declared
      assert service.declared?('MustbeInteger')
      assert service.declared?('MustbeAnother')
    }
  end
end
