# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: :test

# see https://hub.docker.com/_/ruby
namespace :rubyco do
  desc "Build ruby container"
  task :build do
    exec "docker build -t punch-ruby ."
  end

  # $ docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:3.0 bundle install
  desc "Up ruby container"
  task :start do
    pwd = '/usr/src/app'
    vol = "-v \"#{Dir.pwd}\":#{pwd} -w #{pwd}"
    exec "docker run -it --rm --name punch-ruby-dev #{vol} punch-ruby /bin/sh"
  end
end
