require_relative '../../test_helper'
include Punch::Values

describe Param do
  it 'must type_s' do
    para = Param.new('param')
    assert 'Object', para.type_s

    para = Param.new('param:zero_or_more')
    assert 'ZeroOrMore', para.type_s
  end

  it 'must compare through <=>' do
    pos = Param.new('param')
    pos_default = Param.new('param = nil')
    kw = Param.new('param:')
    kw_typed = Param.new('param:type')
    kw_typed_default = Param.new('param:type = nil')

    assert pos < pos_default
    assert pos_default < kw
    assert_equal 0, kw <=> kw_typed
    assert kw < kw_typed_default
    assert kw_typed < kw_typed_default
  end

  it 'must present positional param' do
    raw = 'param'
    dummy = Param.new(raw)
    assert dummy.positional?
    refute dummy.keyword?
    refute dummy.typed?
    refute dummy.tail?

    assert_equal 'Object', dummy.type_s
    assert_equal raw, dummy.define_s
    assert_equal "@#{raw} = #{raw}", dummy.assign_s
    assert_equal "# @param param [Object]\nattr_reader :#{dummy.name}\n", dummy.reader_s
  end

  it 'must present positional param with default value' do
    raw = 'param = nil'
    dummy = Param.new(raw)
    assert dummy.positional?
    refute dummy.keyword?
    refute dummy.typed?
    assert dummy.tail?

    assert_equal 'Object', dummy.type_s
    assert_equal raw, dummy.define_s
    assert_equal "@param = param", dummy.assign_s
    assert_equal "# @param param [Object]\nattr_reader :#{dummy.name}\n", dummy.reader_s
  end

  it 'must present keyword param' do
    raw = 'param:'
    dummy = Param.new(raw)
    assert dummy.keyword?
    refute dummy.positional?
    refute dummy.typed?
    refute dummy.tail?

    assert_equal 'Object', dummy.type_s
    assert_equal raw, dummy.define_s
    assert_equal "@param = param", dummy.assign_s
    assert_equal "# @param param [Object]\nattr_reader :#{dummy.name}\n", dummy.reader_s
  end

  it 'must present keyword param with type' do
    raw = 'param:string'
    dummy = Param.new(raw)
    assert dummy.keyword?
    assert dummy.typed?
    refute dummy.tail?

    assert_equal 'String', dummy.type_s
    assert_equal 'param:', dummy.define_s
    assert_equal "@param = MustbeString.(param)", dummy.assign_s
    assert_equal "# @param param [String]\nattr_reader :#{dummy.name}\n", dummy.reader_s
  end

  it 'must present keyword param with type and default value' do
    raw = "param:string ''"
    dummy = Param.new(raw)
    assert dummy.keyword?
    assert dummy.typed?
    assert dummy.tail?

    assert_equal 'String', dummy.type_s
    assert_equal "param: ''", dummy.define_s
    assert_equal "@param = MustbeString.(param)", dummy.assign_s
    assert_equal "# @param param [String]\nattr_reader :#{dummy.name}\n", dummy.reader_s
  end
end
