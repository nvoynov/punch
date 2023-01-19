require_relative "../../test_helper"
require_relative "../../../lib/assets/domain/sample"
include Punch::Services

describe PunchDomain do
  let(:service) { PunchDomain }

  it 'must punch sample_domain' do
    Sandbox.() {
      domain = build_sample_domain
      log = service.(domain)
      refute log.empty?
      # puts "-= Default Configuration =-"
      # payload = ["lib/config.rb"]
      # puts log
      # print_content(*payload)
    }

    Sandbox.() {
      @config = Punch::Config.new('lib', 'test', 'dom', 'sen', 'ent', 'ser', 'plg')
      domain = build_sample_domain
      log = []
      Punch.stub :config, @config do
        log = service.(domain)
      end
      refute log.empty?
      # puts "-= Custom Configuration =-"
      # payload = ["lib/dom/config.rb", "lib/dom.rb"]
      # puts log
      # print_content(*payload)
    }
  end
end
