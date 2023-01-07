require "punch/dsl"
include Punch

# Design your domain here
# look through sample.rb for details
def build_domain
  DSL::Builder.build('Domain', 'Descriptioin') do

    sentry :string, block: 'v.is_a?(Strinig)'
    sentry :email,  'must be valid email address'
    sentry :secret, 'at least 8 symbols with digits'

    entity :user do
      param :login, :sentry => :email
      param :secret, :sentry => :secret
    end

    entity :credentials do
      param :login, :sentry => :email
      param :secret, :sentry => :secret
    end

    actor :user do
      service :signup do
        param :login, :sentry => :email
        param :secret, :sentry => :secret
      end

      service :signin do
        param :login, :sentry => :email
        param :secret, :sentry => :secret
      end

      service :forget do
        param :login, :sentry => :email
        param :secret, :sentry => :secret
      end
    end

    actor :admin do
      service :query_users do
        param :page_number, :sentry => :page_number
        param :page_size, :sentry => :page_size
      end

      service :lock_user do
        param :login, :sentry => :email
      end

      service :unlock_user do
        param :login, :sentry => :email
      end
    end
  end
end