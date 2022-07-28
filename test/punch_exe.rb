require_relative "test_helper"
require "punch"
require "punch/cli"
include Punch

describe 'exe/punch' do

  SETUP = begin
    system "gem uninstall punch"
    system "git add ."
    system "git commit -m\"test punch exe\""
    system "rake install"
  end

  it 'must print banner' do
    FileBox.() do
      out, _ = capture_subprocess_io { system "punch" }
      assert_match Punch::CLI::BANNER, out
    end
  end

  let(:dummy) { "dummy" }
  it 'must punch dummy' do
    FileBox.() do
      out, _ = capture_subprocess_io { system("punch new #{dummy}") }
      map_logged_to_exist(out).each{|yes| assert yes}
    end
  end

  it 'must init' do
    FileBox.() do
      out, _ = capture_subprocess_io { system("punch init") }
      map_logged_to_exist(out).each{|yes| assert yes}
    end
  end

  it 'must clone clean' do
    Sandbox.() do
      out, _ = capture_subprocess_io { system("bundle") }
      out, _ = capture_subprocess_io { system("punch clone clean") }
      map_logged_to_exist(out).each{|yes| assert yes}
    end
  end

  it 'must punch sentry' do
    Sandbox.() do
      out, _ = capture_subprocess_io { system("bundle") }
      out, _ = capture_subprocess_io { system("punch sentry string") }
      map_logged_to_exist(out).each{|yes| assert yes}
    end
  end

  it 'must punch entity' do
    Sandbox.() do
      out, _ = capture_subprocess_io { system("bundle") }
      out, _ = capture_subprocess_io { system("punch entity user name email") }
      map_logged_to_exist(out).each{|yes| assert yes}
    end
  end

  it 'must punch service' do
    Sandbox.() do
      out, _ = capture_subprocess_io { system("bundle") }
      out, _ = capture_subprocess_io { system("punch service create user name email") }
      map_logged_to_exist(out).each{|yes| assert yes}
    end
  end

  let(:preview) {[
    'lib/services/users/create_user.rb',
    'test/services/users/test_create_user.rb',
    'lib/services/users.rb'
  ]}

  # @todo what's wrong with this one?
  # it 'must preview' do
  #   Sandbox.() do
  #     cmd = "punch preview service users/create_user name email"
  #     out, _ = capture_subprocess_io { system("bundle") }
  #     out, _ = capture_subprocess_io { system(cmd) }
  #     # how to test there?
  #     print_debug_info("punch preview")
  #     puts "result: #{out}"
  #     assert_match %r{users/create_user.rb}, out
  #     assert_match %r{users/test_create_user.rb}, out
  #   end
  # end
end
