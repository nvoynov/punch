require_relative '../../test_helper'
include Punch::Gateways

describe Storage do

  let(:storage) { Storage.new }
  let(:unknown) { Punch::Decor.new('unknown') }
  let(:service) { Punch::Decor.new('service punch') }

  describe '#template' do
    it 'must return template or fail unless found' do
      storage.templates(service)
      assert_raises(ArgumentError) { storage.templates(unknown) }
    end
  end

end
