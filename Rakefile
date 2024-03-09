# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "sancho"
source, folders = Sancho.tasks
Rake.application.rake_require source, folders

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: :test
