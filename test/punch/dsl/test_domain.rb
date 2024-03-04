require_relative '../../test_helper'

class TestDomainDSL < Minitest::Test
  def subject
    DSL::Domain
  end

  def test_build
    dom = subject.() do
      name :spec
      desc 'spec domain'

      entity :user do
        param :email, :sentry => :string, default: 'user', desc: 'user'
        param :secret, :sentry => :secret
      end

      service :create_user do
        param :email, :sentry => :string, default: 'user', desc: 'user'
        param :secret, :sentry => :secret
      end

      actor :user do
        service :login do
          param :email, :sentry => :string, default: 'user', desc: 'user'
          param :secret, :sentry => :secret
        end
      end

      plugin :store
    end
    assert dom
    refute_empty dom.entities
    refute_empty dom.services
    refute_empty dom.actors
    refute_empty dom.actors.first.services
    refute_empty dom.plugins
  end
end
