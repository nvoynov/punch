# Sample domain

require "punch/dsl"
include Punch

def build_sample_domain
  DSL::Builder.build do
    sentry :email, 'must be valid email address'
    sentry :password, 'at least 8 symbols with digits'

    entity :user do
      param :email, :sentry => :email
      param :signed_at
      param :locked_at
      param :locked_by
      param :resigned_at
    end

    entity :secret do
      param :email, :sentry => :email
      param :secret
    end

    # can't see a real thing without plugins
    plugin :storage
    plugin :secrets

    # actor :user here serves for services grouping
    #   and add actor prefix for service name
    actor :user do
      # in this case, Punch will create UserSignUp service
      service :sign_up do
        param :email, :sentry => :email
        param :password, :sentry => :password
      end

      service :sign_in do
        param :email, :sentry => :email
        param :password, :sentry => :password
      end

      service :change_password do
        param :email, :sentry => :email
        param :password, :sentry => :password
        param :new_password, :sentry => :password
      end

      service :resign do
        param :email, :sentry => :email
        param :password, :sentry => :password
      end
    end

    actor :admin do
      service :query_users do
        param :limit, :sentry => :limit
        param :offset, :sentry => :offset
      end

      service :lock_user do
        param :email, :sentry => :email
      end

      service :unlock_user do
        param :email, :sentry => :email
      end
    end
  end
end
