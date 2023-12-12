namespace :docker do

  DOCKER = 'docker'.freeze

  desc 'Up mounted /app'
  task :local do
    # for Docker on Windows, add folder (Settings->Resources->File Sharing) and retart Docker
    # docker run --rm -it --mount type=bind,source=.,destination=/app ruby:3.2.2 /bin/sh
    system "#{DOCKER} run --rm -it --mount type=bind,source=.,destination=/app ruby:3.2.2 /bin/sh"
  end

  desc "Build Docker Image"
  task :build, :tag do |t, args|
    args.with_defaults(tag: 'dummy')
    system "#{DOCKER} build . -t #{args.tag}"
  end

  desc "Run Docker Image"
  task :run, :command do |t, args|
    args.with_defaults(command: '') # /bin/sh
    system "#{DOCKER} run --rm -it --mount type=bind,source=.,destination=/app dummy #{args.command}"
  end

end
