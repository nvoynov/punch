require_relative "../../test_helper"

describe Plugin do
  class PluginSample
    extend Punch::Plugin
  end

  let(:holder) {
    Module.new do
      extend Punch::Plugin::Holder
      plugin PluginSample
    end
  }

  it '#plugin must return Pluging::Holder' do
    assert_kind_of Punch::Plugin::Holder, PluginSample.plugin
  end

  describe Plugin::Holder do
    it 'must be Plugin::Holder' do
      assert_kind_of Punch::Plugin::Holder, holder
      assert_respond_to holder, :plugin
      assert_respond_to holder, :object
      assert_respond_to holder, :object=

      proper = Class.new(PluginSample)
      holder.object = proper.new
      assert_raises(ArgumentError) { holder.object = Object.new }

      holder.plugin Object
      assert_kind_of Object, holder.object
    end
  end

end
