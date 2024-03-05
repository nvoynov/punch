---
title: Punch Readme
keywords:
  - ruby
  - source-code-generator
  - interactor
  - service
  - entity
  - plugin
  - business-logic-layer
  - the-clean-architecture
  - domain-driven-design
...

The Punch is an opinionated Ruby Code Generator for Business Logic Layer, built with principles [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) and Domain Driven Design. Read [Intro](INTRO.md) to gasp some basic ideas.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add punch --git https://github.com/nvoynov/punch.git

## Usage

Run the following command for basic usage:

    $ punch

then punch a new project:

    $ punch new DIRECTORY
    $ cd DIRECTORY

then preview some commands:

    $ punch preview service user-sing-up email
    $ punch preview service user-sign-up email:email
    $ punch preview entity user name email secret
    $ punch preview plugin store

Proceed with customizing templates and "punching" previews when the result will match your expectations (by punching samples and customizing ./punch/samples/*.rb.erb)

    $ punch samples

And maybe finally

    $ punch basics

Advanced Stuff in [DSL](#dsl) section

### Configure

One can configure "punching" process by editing `punch.yml` that says which folder should be used for services, entities, plugins. The defaults are:

```yml
lib: lib
test: test
domain:
sentries: sentries
entities: entities
services: services
plugins: plugins
```

I would recommend set "domain" property - it will structure sources in gem-like manner

### Logging

Punch logs all commands and errors in `punch.log`.

```
[2023-01-12 15:11:34 +0200] INFO : punch plugin store
[2023-01-12 15:11:34 +0200] INFO : lib/plugins/store.rb, lib/plugins.rb~, lib/, test/plugins/test_store.rb
```

### Status

The `$ punch status` command provides you with basic info about "punched" sources, like how many sources you have punched and how many are still in the wild punched state.

### Samples

Punch templates serves exactly to my own needs, but one customize it for its own purpose and shape. These templates are just ERB based on [Punch::Decors::Model](lib/punch/decors/model.rb)

    $ punch samples

simplifying a bit, it's quite simple things models

```ruby
module Punch
  module Models
    Param  = Data.define(:name, :sentry, :default, :desc)
    Model  = Data.define(:name, :params, :desc)
    Plugin = Data.define(:name, :desc)
    Sentry = Data.define(:name, :desc, :proc)
  end
end
```

and decorator

```ruby
module Punch
  module Decors

    class Model < Decor
      def const;          end
      def namespace;      end
      def indentation;    end
      def open_namespace; end
      def close_namespace;end
      def regular_params; end
      def keyword_params; end
      def params_yardoc;  end
      def params_yarpro;  end
      def params_guard;   end
      def test_helper;    end
    end

  end
end
```    

### Basics

When one satisfied with default templates to force the punched code work, one should furnish the project with Punch Basics - Service, Plugin, Sentry. The following command will bring it inside "lib/punch/basics" directory.

### DSL

When one have some sort of domain requirements, understands actors and services, one could use describe the domain by DSL and generate the whole domain "at one punch"

    $ punch domain

Look through [sample.rb](https://github.com/nvoynov/punch/blob/master/lib/assets/domain/sample.rb), express your own and then generate it with `dogen.rb` script.

__NOTE__ besides the ruby code generation, the domain in quite interesting thing to generate whatever you want, like some sort of documentation, diagrams, etc. I generated SRS skeleton for [Marko](https://github.com/nvoynov/marko) with actors, use cases, and entities.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/punch.
