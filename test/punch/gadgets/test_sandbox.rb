require_relative '../../test_helper'

describe 'sandbox' do
  let(:playbox) { PlayboxPort.gateway }
  it 'must provide punched environment' do
    Sandbox.() {
      assert playbox.pwd_punched?
    }
  end
end
