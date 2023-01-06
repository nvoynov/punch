require_relative "../../test_helper"
include Punch::DSL

describe Builder do
  it 'must build domain' do
    dom = Builder.build do
      sentry :string, block: 'v.is_a?(String)'
      sentry :header, block: 'v.is_a?(String) && !v.empty?'

      entity :user do
        param :login, keyword: false
        param :secret, keyword: false, default: 'pa$$w0rd'
      end

      entity :credentials do
        param :email
        param :secret
      end

      actor :user do
        service :sign_on do
          param :email
          param :secret
        end

        service :sign_in do
          param :email
          param :secret
        end
      end

      actor :admin do
        service :query_users

        service :lock_user do
          param :email
        end

        service :unlock_user do
          param :email
        end
      end
    end

    assert_kind_of Domain, dom
    assert_equal 2, dom.sentries.size
    assert_equal 2, dom.entities.size
    assert_equal 2, dom.actors.size
  end
end
