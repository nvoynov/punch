require_relative "domain"
require "punch"
include Punch::Services

# PLease note that punch.yml points target forlders for punching
# Maybe you want domain inside 'lib/domain' instead of just 'lib'

domain = build_domain
callback = proc{|event, payload| puts "- punching #{payload}.." }
puts "Punching Domain Skeleton.."
PunchDomain.(domain, &callback)
puts "Success!"
puts Dir.glob("#{Punch.config.lib}/**/*.rb").map{ "- #{_1}" }
