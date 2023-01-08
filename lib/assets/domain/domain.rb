require "punch/dsl"
include Punch

# Design your domain here
# look through sample.rb for details
def build_domain
  DSL::Builder.build do
    # sentry "User Name",  'must be String[3, 100]'
    # sentry :email,  'must be valid Email addresss'
    # sentry :secret, 'at least 8 symbols with digits'

    # entity :user do
    #   param :login, :sentry => :email
    #   param :secret, :sentry => :secret
    # end

    # core service
    # service "Login" do
    #   param :email,  :sentry => :email
    #   param :secret, :sentry => :secret
    # end

    # actors services
    # actor :user do
    #   service "Sing Up" do
    #     param :name,  :sentry => :user_name
    #     param :email, :sentry => :email
    #   end
    # end
  end
end
