require_relative "../../test_helper"

describe Plugin do
  class Dummy
    extend Plugin
  end

  let(:holder) {
    Module.new do
      extend Plugin::Holder
      plugin Dummy
    end
  }

  it '#plugin must return Pluging::Holder' do
    assert_kind_of Plugin::Holder, Dummy.plugin
  end

  describe Plugin::Holder do
    it 'must be Plugin::Holder' do
      assert_kind_of Plugin::Holder, holder
      assert_respond_to holder, :plugin
      assert_respond_to holder, :object
      assert_respond_to holder, :object=

      proper = Class.new(Dummy)
      holder.object = proper.new
      assert_raises(ArgumentError) { holder.object = Object.new }

      holder.plugin Object
      assert_kind_of Object, holder.object
    end
  end

end
