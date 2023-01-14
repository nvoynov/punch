require_relative "../test_helper"

class TestConfig < Minitest::Test
  def test_settings
    assert_equal Dir.pwd, Punch.root
    assert_equal File.join(Dir.pwd, 'lib', 'assets'), Punch.assets
    assert_equal File.join(Dir.pwd, 'lib', 'punch', 'basics'), Punch.basics
    assert_equal File.join(Punch.assets, 'starter'), Punch.starter
    assert_equal File.join(Punch.assets, 'samples'), Punch.samples
    assert_equal File.join(Punch.assets, 'domain'), Punch.domain
  end

  def test_config
    Tempbox.() {
      # not exist
      conf = Punch.config
      assert_respond_to conf, :lib
      assert_respond_to conf, :test
      assert_respond_to conf, :domain
      assert_respond_to conf, :sentries
      assert_respond_to conf, :services
      assert_respond_to conf, :entities
      assert_respond_to conf, :plugins

      # proper
      File.write(Punch::CONFIG, <<~EOF
        lib: lib
        test: test
        domain: proper_domain
        sentries: sentries
        services: services
        entities: entities
        plugins: plugins
      EOF
      )
      conf = Punch.config
      assert_kind_of Punch::Config, conf
      assert_equal 'proper_domain', conf.domain

      # faulty
      File.write(Punch::CONFIG, 'faulty maulty')
      config = Punch.config
      assert_kind_of Punch::Config, config
    }
  end
end
