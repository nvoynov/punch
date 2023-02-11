# frozen_string_literal: true

# require "rake"
# sancho = File.expand_path("../sancho", __dir__)
# sancho = File.join(sancho, 'lib')
# Rake.application.rake_require "tasks", [sancho]

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: :test
