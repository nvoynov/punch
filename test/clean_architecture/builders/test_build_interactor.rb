require_relative '../test_helper'

describe CleanArchitecture::Builders::BuildInteractor do
  let(:domain)  { CleanArchitecture::Builders::BuildDomain.call('domain') }
  let(:subject) { CleanArchitecture::Builders::BuildInteractor }
  let(:foo) { SYN::Parameter.new(name: 'foo') }
  let(:bar) { SYN::Parameter.new(name: 'bar') }
  
  it 'make' do
    interactor = subject.call('run', [foo, bar], domain)
    assert_kind_of CleanArchitecture::Entities::Interactor, interactor
    assert_equal domain.interactors, interactor.parent    
    refute_empty interactor.kmethods
    assert_empty interactor.kproperties
  end
end
