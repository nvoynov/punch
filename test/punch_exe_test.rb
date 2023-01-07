require_relative "test_helper"

describe 'exe/punch' do
  def punched_bundled
    path = File.dirname(__dir__)
    body = <<~EOF
      source "https://rubygems.org"
      gem "punch", path: "#{path}"
    EOF

    Sandbox.() {
      File.write('Gemfile', body)
      system "bundle install"
      yield if block_given?
    }
  end

  it 'must punch service' do
    punched_bundled {
      system "punch"
      system "punch preview service signup email user"
    }
  end
end
