require_relative "../../test_helper"
require_relative "../../../lib/assets/domain/sample"
include Punch::Services

describe PunchDomain do
  let(:service) { PunchDomain }

  it 'must punch sample_domain' do
    Sandbox.() {
      domain = build_sample_domain
      log = service.(domain)
      refute_empty log
      # puts "-= Default Configuration =-"
      # payload = ["lib/config.rb"]
      # puts log
      # print_content(*payload)
    }

    Sandbox.() {
      @config = Config.new(domain: 'dom')
      domain = build_sample_domain
      log = []
      ConfigHolder.stub :object, @config do
        log = service.(domain)
      end
      refute_empty log
    }
  end
end
