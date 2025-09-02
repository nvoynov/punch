require_relative '../test_helper'

describe CleanArchitecture::Builders::BuildDomain do
  let(:subject) { CleanArchitecture::Builders::BuildDomain }

  it 'make' do
    dom = subject.call('domain')
    assert_kind_of CleanArchitecture::Entities::Domain, dom
    assert dom.interactors
    assert dom.entities
    assert dom.ports
  end
end
