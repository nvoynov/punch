---
title: Punch Changelog
...

## [Unreleased]

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
