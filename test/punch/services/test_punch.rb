require_relative '../../test_helper'

describe Services::Punch do

  let(:puncher) { Services::Punch }

  describe '#failure' do
    it 'must fail when directore did not punched' do
      FileBox.() { assert_raises(ArgumentError) { puncher.() } }
    end

    it 'must fail for wrong arguments' do
      Sandbox.() { assert_raises(ArgumentError) { puncher.(42) } }
    end

    # by decorator
    it 'must fail for wrong klass' do
      Sandbox.() { assert_raises(ArgumentError) { puncher.('unknown a') } }
    end
  end

  describe '#success' do
    let(:sentry) { "sentry string message v.is_a?(String) description" }
    let(:entity) { "entity user name email" }
    let(:service) { "service create_user name:string email:email" }

    it 'must punch sentry' do
      Sandbox.() do
        log = puncher.(sentry)
        assert_equal 2, log.size # sentries.rb, test/test_string.rb
        log.each{|filename| assert File.exist?(filename)}
      end
    end

    it 'must punch entity' do
      Sandbox.() do
        log = puncher.(entity)
        assert_equal 3, log.size # entities.rb, entities/entity.rb, test/test_string.rb
        log.each{|filename| assert File.exist?(filename)}
        # log.each{|filename| puts "\n-= #{filename} =-\n"; puts File.read(filename)}
      end
    end

    it 'must punch service' do
      Sandbox.() do
        log = puncher.(service)
        # lib/sentries.rb
        # test/sentries/test_string.rb
        # test/sentries/test_email.rb
        # lib/services/create_user.rb
        # test/services/test_create_user.rb
        # lib/services.rb
        assert_equal 6, log.size
        log.each{|filename| assert File.exist?(filename)}
      end
    end
  end
end
