require_relative "domain"
require "punch"
include Punch::Services

domain = build_domain

# punch sentries
print "punching sentries.. "
PunchSentry.(*sentries.values)
puts "OK"

print "punch entities.. "
PunchSource.(:entity, *domain.entities)
puts "OK"

print "punch services.. "
PunchSource.(:service, *domain.services)
puts "OK"

# How about punching next
# - SRS skeleton of users, services, entities?
# - domain interface, like api?
# - help for the interface, like Swagger?
