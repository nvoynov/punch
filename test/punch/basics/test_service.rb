require_relative "../../test_helper"

class TestService < Minitest::Test
  def service
    Punch::Service
  end

  def test_overrided
    assert_raises(RuntimeError) { service.() }
  end

  def test_default_constructor
    dummy = Class.new(service) do
      def call
        [@args, @kwargs, @block]
      end
    end
    payload = dummy.()
    assert_equal [], payload[0]
    assert_equal Hash.new, payload[1]
    refute payload[2]

    payload = dummy.(1, 2, o: 3)
    assert_equal [1, 2], payload[0]
    assert_equal Hash[o: 3], payload[1]
  end
end
