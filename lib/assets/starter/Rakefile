# frozen_string_literal: true
require "rake"
require "rake/testtask"
Rake.application.rake_require "docker", ["."]

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: :test
