# frozen_string_literal: true

require_relative "lib/punch/version"

Gem::Specification.new do |spec|
  spec.name = "punch"
  spec.version = Punch::VERSION
  spec.authors = ["Nikolay Voynov"]
  spec.email = ["nvoynov@gmail.com"]

  spec.summary = "Source Code Puncher (Generator) for the core layer of The Clean Architecture. It provides customizable templates of the core architecture concepts (services, entities, plugins), domain DSL, and CLI."
  spec.description = "Punch eliminates the tedious work of creating and requiring source code for The Clean Architecture concepts by using concise and effective CLI and DSL. That is supposed to increase your productivity and boost code architecture."
  spec.homepage = "https://github.com/nvoynov/punch"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
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
