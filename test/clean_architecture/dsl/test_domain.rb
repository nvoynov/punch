require_relative '../test_helper'

describe CleanArchitecture::DSL::Domain do
  let(:subject) { CleanArchitecture::DSL::Domain }

  it '#make' do
    domain = subject.make('punch') do
      entity :foo, 'foo entity' do 
        property :foo, 'foo property'
      end
      
      interactor :alpha do
        parameter :foo, 'user foo'
        parameter :bar, 'user bar'
      end

      port :store, 'data store' do
        kmethod :get, 'get stored object' do
          parameter :key, 'access key'
        end
        
        kmethod :put, 'store object' do
          parameter :key, 'access key'
        end
      end
    end

    assert_kind_of SYN::KModule, domain
    # pp domain
  end
end
