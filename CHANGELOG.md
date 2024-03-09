---
title: Punch Changelog
...

## TODO

- [ ] furniture empty folder "md project; cd project; punch init"
- [ ] place docker.rake at lib/tasks
- [ ] provide default service
- [ ] assets/samples tests
- [ ] PunchXyz tests for proper log, to avoid the necessity of 0.7.1 :)
- [ ] test_cli.rb under "bundle exec rake test" with CLEAN console
- [ ] test_exe.rb under "bundle exec rake test" with CLEAN console

## [Unreleased]

## [0.7.3] - 2024-03-09

- removed entity from punch basics result
- designed new BuildReport service that builds report in Markdown (lib/assets/report.md.erb)
- designed new INTRO.md
- redesigned README.md
- updated "sancho" gem, Rakefile, Gemfile
- removed "docs" branch
- fixed Sentry decorator for CAPITAL case Uuid instead of UUID
- fixed PunchSentries that punched tests under lib/sentries/test_sentry.rb
- fixed PunchModel that log lib/services.rb~ punching the first service

## [0.7.0] - 2024-03-04

A few weeks ago I finished the first commercial backend for a small domain of one actor, a dozen services, four entities, and three plugins. The domain was "punched" using Punch::DSL; bumped in a few inconveniences that were fixed by this release.

- designed new model based on Data class
- designed new DSL for Data class
- designed new decorators - no more paths calculating stuff
- designed new [entity sample](lib/punch/assets/samples/entity.rb.erb) based on Ruby 3.2 Data class
- desgined new PunchSentries service
- desgined new PunchModel service (paths calculating stuff moved here) with PunchEntity, PunchService, PunchPlugin descendants
- designed new Config based on Data
- decision to use positional or keyword arguments moved into samples/\*.rb.erb - one could replace `@model.keyword_params` for `@model.regular_params` (see [model decorator](lib/punch/decors/model.rb) for other methods); can't see the reson to use different approach in one project
- removed the ability of using nested folders for generated concepts; invoke `$ punch new service user/crate-order` will generate `lib/domain/services/user_create_order.rb`
- removed extra `lib/punch/basic/entity.rb`
- simplified plugin and test_plugin samples

## [0.6.4] - 2023-12-12

- moved to Ruby 3.2.2 (Psych and Tests)
- added .dockerignore
- added doker.rake
- changed Dockerfile

## [0.6.3] - 2023-01-24

- removed `plugin/logger`, replaced by regular Ruby Logger
- added few extra sample generators based on `DSL::Domain`

## [0.6.2] - 2023-01-19

- fixed typo in `$ punch status`
- added `README.md` and `Dockerfile` for `$ punch new`
- improved `PunchPlugin` for using `domain` setting
- improved samples
  - entities require `entity` instead of `../basics`
  - services require `service` instead of `../basics`
  - services `initialize` equipped with yardoc
  - all tests are skipped by `skip "UNDER CONSTRUCTION"`
- improved README.md

## [0.6.1] - 2023-01-14

- improved CLI by logging exception backtrace
- improved `CLI::BANNER`
- improved `Punch.config` for better `punch.yml`
- improved `PunchDomain` by returning log like other punchers
- improved `$ punch basics` by accounting for `domain` setting
- optimized most of `assets/samples`
- updated README.md with `punch_users` statistics

## [0.6.0] - 2023-01-10

- added `Punch::DSL::Plugin` and `DSL::Builder#plugin`
- added `PunchPlugin` service that creates `config.rb` with plugin holders
- fixed `ModelDecor#test_helper` that added one extra `../`
- fixed "spontaneous" call for `punch_basics` in `PunchSource`
- improved `Punch::Config` by providing `domain` configuration
- improved `domain/sample.rb`
- improved `Punch::DSL#actor` that create service as `actor.name + ?\s + name`
- improved `ModelDecor#test_helper` to take `config.test` into account
- improved starter `Gemfile` with `gem "rake"`
- improved `Service` with `failure` method
- changed `Playbox` assets punching as
  - `$ punch samples` to `.punch/samples`
  - `$ punch domain` to `.punch/domain`
  - `$ punch basics` to `lib/punch/basics`
- improved `PunchDomain` service, based on `Punch::Config.domain` when provided, it creates `<domain>.rb` that requires sentries, entities, services, plugins, basics, and config

## [0.5.1] - 2023-01-08

- added test for `punch/basics`
- added `PunchDomain` service
- changed `domain/dogen.rb` for using `PunchDomain`
- optimized samples
- optimized README

## [0.5.0] - 2023-01-06

- source code completely redesigned
- added ability to punch plugins
- added DSL for design domains
- PORO, no dependencies except Bundler and Minitest

## 2022-07-11

- Project started
