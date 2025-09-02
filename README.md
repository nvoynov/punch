---
title: Punch Readme
keywords:
  - ruby
  - code-generator
  - interactor
  - entity
  - gateway
  - port
  - business-logic-layer
  - the-clean-architecture
  - domain-driven-design
...

The Punch is an opinionated Ruby Code Generator for Business Logic Layer, built with principles [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) and Domain Driven Design. Read [Intro](INTRO.md) to gasp some basic ideas.

## Intro

Playing with [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) in 2021 I found it just an amazing tool, but a bit tiresome also because of the necessity to constantly create and require a bunch of standard source like entities, interactors and iths tests. That was the reason for designing Punch.

I wanted just a few things

1. Start as small as possible with PORO by adopting entities, interactors, and ports (gateways); postponing technologies (CLI, Web, Message Broker, Data Storage, etc.)
2. Punch (generate, instead of writing manually) interactors and entities to boost productivity and reduce manual work.

## Installation

Install the gem by cloing the repository

    $ git clone https://github.com/nvoynov/punch.git
    $ cd punch
    $ rake install

## Usage

Run the following command for basic usage help:

    $ punch

Punch new ruby project directory and run some commands

    $ punch ruby thing
    $ cd thing
    $ punch clean domain thing
    $ punch clean interactor "sign in" email password
    $ punch clean entity credentials email password
    $ punch clean port "data store" all put get

### Clean domain

    $ punch clean domain thing

The command creates the followins sources:

1. clean_architecture.yml with the domain name
2. lib/thing.rb
3. lib/thing/interactors.rb
3. lib/thing/entities.rb
3. lib/thing/ports.rb

### Clean thing

    $ punch clean CONCEPT NAME [PARAM1 PARAM2 PARAM3]

The command creates a clean component sources, depending on the CONCEPT prameters will be treated as properties or method parameters.

    $ punch clean interactor "sign in" email password

Will create

1. lib/thing/interactors/sign_in.rb
2. test/thing/interactors/test_sign_in.rb

And rewrite lib/thing/interactors.rb by requiring the new interactor (require_relative "ineractors/sign_in")

Interactor and Entity are simple POROs

```ruby
# SignIn
class SignIn
  # @param email [Object]
  # @param password [Object]
  def call(email, password)
    # TODO: implement me
  end
end

# Credentials
class Credentials
  # @return [Object]
  attr_reader :email
  # @return [Object]
  attr_reader :password

  # @param email [Object]
  # @param password [Object]
  def initialize(email, password)
    @email = email
    @password = password
  end
end
```


[Sources rewriting]{.underline}

Each generated source will have banner comment with MD5 from content. When one punches file that already exists, punch will check content changes. When one changes source file content (content does not match MD5), punch will hold manual changes and show exclamation mark in log before the filename

    $ punch clean entity credentials email password
      lib/clean/entities.rb
      lib/claen/entities/credential.rb
      test/clean/entities/test_credentials.rb

Suppose, one changed `credential.rb` file. Then running the command again, one will see

    $ punch clean entity credentials email password
      ..
      !lib/claen/entities/credential.rb
      ..

### Clean DSL

    $ punch clean dsl DSLFILE

The command will punch clean domain build from DSLFILE. One can find the DSL example in [test_dsl.rb](TODO)

### Pipe and Filter

Future puncher will be about pipe and filter

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/punch.
