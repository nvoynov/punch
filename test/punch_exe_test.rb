require_relative "test_helper"

describe 'exe/punch' do

  # it 'must punch basics, samples, and domain' do
  #   punched_bundled {
  #     system "punch basics"
  #     system "punch samples"
  #     system "punch domain"
  #   }
  # end

  it 'must punch and preview services and entities' do
    punched_bundled {
      system "punch service sign_up email secret"
      system "punch service sign_in email secret"
      system "punch plugin storage"
      system "punch preview service sign_in email secret"
      system "punch status"
    }
  end

  # it 'must abort punching changed sources' do
  #   punched_bundled {
  #     system "punch service sign_up email secret"
  #     # change servie content and check for abort
  #     name = 'lib/services/sign_up.rb'
  #     prev = File.read(name)
  #     File.open(name, 'a') {|f| f.puts "changed"}
  #     out, _ = capture_subprocess_io {
  #       system "punch service sign_up email secret"
  #     }
  #     assert_match %{#{name}!}, out
  #   }
  # end

  def punched_bundled
    path = File.dirname(__dir__)
    body = <<~EOF
      source "https://rubygems.org"
      gem "punch", path: "#{path}"
    EOF

    Sandbox.() {
      File.write('Gemfile', body)
      system "bundle install"
      # system "bundle show punch"
      yield if block_given?
    }
  end
end
