require_relative '../test_helper'

describe CleanArchitecture::Builders::BuildEntity do
  let(:domain)  { CleanArchitecture::Builders::BuildDomain.call('domain') }
  let(:subject) { CleanArchitecture::Builders::BuildEntity }
  let(:foo) { SYN::KProperty.new(name: 'foo') }
  let(:bar) { SYN::KProperty.new(name: 'bar') }
  
  it 'make' do
    entity = subject.call('domain', [foo, bar], domain)
    assert_kind_of CleanArchitecture::Entities::Entity, entity
    assert_equal domain.entities, entity.parent
    refute_empty entity.kmethods
    refute_empty entity.kproperties
  end
end
