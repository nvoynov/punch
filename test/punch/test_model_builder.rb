require_relative "../test_helper"

class TestModelBuilder < Minitest::Test
  def builder
    ModelBuilder
  end

  def test_call
    m = builder.('model')
    assert_kind_of Model, m
    assert_equal 'model', m.name
    assert m.params.empty?

    m = builder.('model', 'a')
    assert_equal 1, m.params.size

    param = m.params[0]
    assert_equal 'a', param.name
    assert param.positional?
    refute param.keyword?
    refute param.default?
    refute param.sentry?

    m = builder.('model', 'a:b "42"')
    param = m.params[0]
    assert_equal 'a', param.name
    refute param.positional?
    assert param.keyword?
    assert param.default?
    assert param.sentry?
  end
end
