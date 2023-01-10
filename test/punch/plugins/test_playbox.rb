require_relative "../../test_helper"
require 'fileutils'
include FileUtils

class TestPlaybox < Minitest::Test
  def playbox
    @playbox ||= Playbox.new
  end

  def basename(ary)
    ary.map{|n| File.basename(n)}
  end

  def test_write
    source = 'dummy.txt'
    backup = 'dummy.txt~'
    failed = 'dummy.txt!'
    sample = 'foo bar'

    Tempbox.() {
      log = playbox.write(source, sample)
      assert_equal [source], log
      refute playbox.updated?(source)

      log = playbox.write(source, sample)
      assert_equal [backup, source], log
      refute playbox.updated?(source)

      # append
      File.open(source, 'a') do |f|
        f.puts "manually changed"
      end
      assert playbox.updated?(source)
      log = playbox.write(source, sample)
      assert_equal [failed], log
    }
  end

  def test_punch_basics
    Sandbox.() {
      glob = playbox.punch_basics
      orig = Dir.glob("#{Punch.basics}/**/*")
      # a bit weird
      orig.push('basics.rb', 'punch.rb', 'basics.rb')
      assert_equal basename(orig), basename(glob)
    }
  end

  def test_punch_samples
    Sandbox.() {
      glob = playbox.punch_samples
      orig = Dir.glob("#{Punch.samples}/**/*")
      assert_equal basename(orig), basename(glob)
    }
  end

  def test_punch_domain
    Sandbox.() {
      glob = playbox.punch_domain
      orig = Dir.glob("#{Punch.domain}/**/*")
      assert_equal basename(orig), basename(glob)
    }
  end

  def test_samples
    Sandbox.() {
      samples = playbox.samples(:sentry)
      assert_equal 2, samples.size

      samples = playbox.samples(:entity)
      assert_equal 2, samples.size

      samples = playbox.samples(:service)
      assert_equal 2, samples.size

      assert_raises(ArgumentError) { playbox.samples(:faulty) }
    }
  end
end
