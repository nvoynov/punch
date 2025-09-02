require_relative '../test_helper'

describe CleanArchitecture::Builders::BuildPort do
  let(:domain)  { CleanArchitecture::Builders::BuildDomain.call('domain') }
  let(:subject) { CleanArchitecture::Builders::BuildPort }
  let(:foo) { SYN::Parameter.new(name: 'foo') }
  let(:bar) { SYN::Parameter.new(name: 'bar') }
  let(:get) { SYN::KMethod.new(name: 'get', parameters: [foo, bar]) }
  let(:put) { SYN::KMethod.new(name: 'put', parameters: [foo, bar]) }
  
  it 'make' do
    port = subject.call('store', [get, put], domain)
    assert_kind_of CleanArchitecture::Entities::Port, port
    assert_equal domain.ports, port.parent
    refute_empty port.kmethods
  end
end
