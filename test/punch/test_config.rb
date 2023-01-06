require_relative "../test_helper"

describe 'Config' do

  it 'must provide ..' do
    assert_equal Dir.pwd, Punch.root
    assert_equal File.join(Dir.pwd, 'lib', 'assets'), Punch.assets
    assert_equal File.join(Dir.pwd, 'lib', 'punch', 'basics'), Punch.basics
  end
end
