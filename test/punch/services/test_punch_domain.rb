require_relative "../../test_helper"
require_relative "../../../lib/assets/domain/sample"
include Punch::Services

describe PunchDomain do
  let(:service) { PunchDomain }

  it 'must punch sample_domain' do
    Sandbox.() {
      domain = build_sample_domain
      service.(domain)
    }

    Sandbox.() {
      @config = Punch::Config.new('lib', 'test', 'dom', 'sen', 'ent', 'ser', 'plg')
      @domain = build_sample_domain
      Punch.stub :config, @config do
        service.(@domain)
      end
      # payload = [
      #   "lib/dom/ser/admin_lock_user.rb",
      #   "test/dom/ser/test_admin_lock_user.rb",
      #   "lib/dom/plg.rb",
      #   "lib/dom/plg/secrets.rb",
      #   "test/dom/plg/test_secrets.rb",
      #   "lib/dom/sen.rb",
      #   "lib/dom.rb",
      # ]
      # puts "-= Custom Configuration =-"
      # print_folders
      # print_content(*payload)
    }
  end
end
