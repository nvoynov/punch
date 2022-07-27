require_relative '../../test_helper'
include Punch::Entities

describe Param do

  it '#new must accept name and type' do
    para = Param.new("name")
    assert para.name
    refute para.type
    refute para.kwarg?

    para = Param.new("name:type")
    assert para.name
    assert para.type
    assert para.kwarg?

    para = Param.new("name:")
    assert para.name
    refute para.type
    assert para.kwarg?
  end

end

describe Model do

  let(:entity) { %w(user para1:type1 para2:type2 para3) }
  it '#new must accept array<String>' do
    # parsed from $ punch entity user para1:type1 para2:type2 para3
    # parsed from $ punch service create_user para1:type1 para2:type2 para3
    mod = Model.new(*entity)
    assert_equal 'user', mod.name
    assert_equal 3, mod.params.size
  end

  it 'must recognise namespace' do
    mod = Model.new('create')
    assert_equal 'create', mod.base_name
    assert_equal '', mod.namespace

    mod = Model.new('core/services/create')
    assert_equal 'create', mod.base_name
    assert_equal 'core/services', mod.namespace
  end
end
