% CHANGELOG

## TODO

- [ ] Replace the Punch gem by it, fixing exe/punch
- [ ] provide interactor and CLI for generating DSL
- [ ] design PipeAndFilter with DSL and Puncher

## v0.8.0 (2025-Sep-03)

Punch drastically redesigned.

- Based on code generator not ERB
- Simple interface of punch ruby/clean
- Separate Clean Architecture extension
- Pure exe/punch, no hassle with Gemfile

## 2025-Aug-28

Punch v0.7.0 causes too much of confusion and screams for redesign.

- Complicated installation and weird Sancho must be changed
- Statistic have no sense in real work
- Code generator have to replace ERB templates
- Sentry belongs to Boundary layer, not Domain; and it's weird
- Service is too generic name and causes confusion with service object and maybe application serivces
- Plugin have no connection with Gateway or Port concept
- Basic layer have no sense without Sentry and Plugin
