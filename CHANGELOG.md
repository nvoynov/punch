## [Unreleased]

> Solution does non exists unless tested

- [ ] `<% include Punch::ErbHelper -%>` why this does not work?
- [ ] content MD5 hashing; a file was "punched" but was it touched after?
- [ ] `punch stat` prints some "punching" statistic based on MD5 and log

## [0.2.0] - 2022-07-31

- Param and Model became Clean::Value
- Param accepts default values like `param = nil`, `param:string = "42"`
- Changed erb-helper for simplicity
- Improved `exe/punch`;
  - banner gives some examples;
  - removed `punch sentry`.
- Removed log info `Playbox changed to preview`
- Improved README

## [0.1.1] - 2022-07-28

- Sandbox moved to test_helper.rb
- Fixed CLI#preview
- Improved Logr
- Improved Playbox - now it "punch" in the order of 1) source, 2) include, 3) test
- Improved exe
- Improved README

## [0.1.0] - 2022-07-27

- Initial release

## 2022-07-11

- Project started
