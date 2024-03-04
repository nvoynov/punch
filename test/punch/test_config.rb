require_relative "../test_helper"

describe Punch do
  it {
    assert_equal Dir.pwd, Punch.root
    assert_equal File.join(Dir.pwd, 'lib', 'assets'), Punch.assets
    assert_equal File.join(Dir.pwd, 'lib', 'punch', 'basics'), Punch.basics
    assert_equal File.join(Punch.assets, 'starter'), Punch.starter
    assert_equal File.join(Punch.assets, 'samples'), Punch.samples
    assert_equal File.join(Punch.assets, 'domain'), Punch.domain
  }
end

describe Config do
  it {
    Tempbox.() {
      refute File.exist?(Punch::CONF)
      conf = Config.read
      assert File.exist?(Punch::CONF)
      custom = <<~EOF
        lib: lib
        test: test
        domain: domain
        sentries: sentries
        services: services
        entities: entities
        plugins: plugins
      EOF
      File.write(Punch::CONF, custom)
      conf = Config.read
      assert_equal 'domain', conf.domain

      # faulty
      _, _ = capture_io do
        File.write(Punch::CONF, 'faulty')
        conf = Config.read
        assert_empty conf.domain
      end
    }
  }
end
