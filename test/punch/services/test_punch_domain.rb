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
  end
end
