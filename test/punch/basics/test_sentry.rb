require_relative "../../test_helper"

class TestSentry < Minitest::Test
  def sentry
    Punch::Sentry
  end

  def error_message
    'must be String[3..100]'
  end

  def dummy
    sentry.new(:str, error_message
    ) {|v| v.is_a?(String) && v.size.between?(3,100)}
  end

  def test_new
    # check argumenths
    assert_raises(ArgumentError) { sentry.new }
    assert_raises(ArgumentError) { sentry.new("") }
    assert_raises(ArgumentError) { sentry.new("", "") }
  end

  def test_error
    assert dummy.error("ab")
    refute dummy.error("abc")
    assert_match error_message, dummy.error('')

    key = "key"
    msg = "msg"
    assert_match ":#{key} #{msg}", dummy.error("", key, msg)

    key = :key
    assert_match ":#{key} #{msg}", dummy.error("", key, msg)
  end

  def test_error!
    proper = "proper"
    faulty = "ab"

    assert_equal proper, dummy.(proper)
    err = assert_raises(ArgumentError) { dummy.(faulty) }
    assert_match error_message, err.message
  end
end
