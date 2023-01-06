require_relative "../../test_helper"
include Punch::Services

describe PunchSource do
  let(:service) { PunchSource }

  let(:dummy) { ModelBuilder.('dummy', 'a', 'b:integer 42') }
  let(:extra) { ModelBuilder.('extra', 'a', 'b:integer 42') }

  it 'must punch fail for faulty arguments' do
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(:unknown, dummy) }
  end

  # @todo check result
  it 'must punch a sentry and service' do
    Sandbox.() {
      service.(:service, dummy, extra)
      assert File.exist?('lib/sentries.rb')
      assert File.exist?('test/sentries/test_integer.rb')
      assert File.exist?('lib/services.rb')
      assert File.exist?('lib/services/dummy.rb')
      assert File.exist?('lib/services/extra.rb')
      assert File.exist?('test/services/test_dummy.rb')
      assert File.exist?('test/services/test_extra.rb')
    }

    Sandbox.() {
      service.(:entity, dummy, extra)
      assert File.exist?('lib/sentries.rb')
      assert File.exist?('test/sentries/test_integer.rb')
      assert File.exist?('lib/entities.rb')
      assert File.exist?('lib/entities/dummy.rb')
      assert File.exist?('lib/entities/extra.rb')
      assert File.exist?('test/entities/test_dummy.rb')
      assert File.exist?('test/entities/test_extra.rb')
    }
  end

end
