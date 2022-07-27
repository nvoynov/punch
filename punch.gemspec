# frozen_string_literal: true

require_relative "lib/punch/version"

Gem::Specification.new do |spec|
  spec.name = "punch"
  spec.version = Punch::VERSION
  spec.authors = ["Nikolay Voynov"]
  spec.email = ["nvoynov@gmail.com"]

  spec.summary = "Source Code generator based on Clean"
  spec.description = <<~EOF
     Sort of adaptation of The Clean Architecture principles. Created to boost code architecture with Clean concepts and increase productivity by entrusting tedious work to the Punch code generator.

     Keep code clean, and happy punching!
  EOF
  spec.homepage = "https://github.com/nvoynov/punch"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
