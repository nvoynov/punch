# Punch

Punch focuses on domain business logic layer design in accordance with the principles of [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

The basic idea is to provide a clean robust frame for business-logic design and bring efficiency by generating source code instead of writing manually.

## User Stories

Punch has started from just a few following stories that I hope clearly translate its premises and will still be relevant as the project goes further.

**Architecture** I want to design my code base in accord with The Clean Architecture principles, so it will be easy to write, read, test, and evolve.

**Business logic** I want to start as small as possible just with PORO business logic by adopting just a few core concepts (Service, Entity, Plugin) so that I will have a clean domain at the beginning. When my business logic is ready I'll get to particular technologies (CLI, Web, API, Message Broker, Storage, external API, etc.)

**Generators** I want to have a few generators for my basic concepts (entities, services), that way I hope to boost my productivity and reduce mistakes through generating instead of writing manually.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add punch --git https://github.com/nvoynov/punch.git

## Usage

### Quickstart

Just run `$ punch` and see banner for basic usage, create a new Punch Project by `$ punch new DIRECTORY`, and run a few `$ punch preview` commands inside the `DIRECTORY`.

### Configuration

Punch can be configured through `punch.yml` file that can be found inside your punch project. One can point out directories for punching based on a particular concept. The default settings are

```yml
--- !ruby/struct:Punch::Config
lib: lib
test: test
sentries: sentries
entities: entities
services: services
plugins: plugins
```

In accordance with these settings `Punch` will generate code inside `lib` folder and tests inside `test`. [Sentries](#sentry) will be punched into `lib/sentries.rb`, entities and services respectively into `lib/entities` and `lib/services`.

When you change it like follows,

```yml
--- !ruby/struct:Punch::Config
lib: app/domain
test: test/domain
sentries: core/sentries
entities: core/entities
services: core/usecases
plugins: core/plugins
```

Punch will generate code inside `lib/domain` and tests inside `test/domain` folders, and besides, sentries will be placed into `app/domain/core/sentries.rb`, services into `app/domain/core/usecases`, entities into `app/domain/core/entities`.

Although Punch is not about data store, punching ActiveRecord or Sequel model will be easy enough, you might just configure `entities: models` and provide your own templates (see [templates](#templates) section.)

### "punch service"

The `$ punch service NAME [PARM] [PARAM] ...` command will punch a new service- and its test into your "punched" project. Code will be generated only when the current folder contains `punch.yml`.

The output of the command will be the list of created or modified source files by the command. It is safe enough to prevent you from losing important changes inside punched sources. So when you "punched" some source and then "re-punch" the same concept again, Punch will check was the content changed from its punched state. The command will be aborted for changed content, or the previous copy will be backed for "wild-punched" content.

When you run something like `$punch service sign_up login secret`, Punch will generate code according with service template, something like follows

```ruby
module Services
  class SignUp < Service
    def initialize(login, secret)
      @login = login
      @secret = secret
    end

    def call
    end
  end
end
```

The `login` and `secret` parameters there could be passed in a few ways and the chosen way will affect for code generation output.

1. Finishing parameters with `:` will tell the Punch to generate keyword arguments, so `sign_up loging: secret:` will generate constructor declaration as `def initialize(login:, secret:)`
2. Providing default values for parameters like `sign_up "login \"user\"" "secret \"$ecret\""` will generate `def initialize(login = "user", secret = "$ecret")`
3. In the same manner you can provided default values for keyword arguments - `sign_up "login: \"user\"" "secret: \"$ecret\""` will generate `def initialize(login: "user", secret: "$ecret")`
4. Positional and keyword arguments can be mixed together. Punch is advanced enough to place it into right order - positional first, positional with default values next, and keywords at the end.

And finally we can meet the [Sentry](#sentry). For keyword arguments you can point a sentry, and being pointed for an argument, constructor will validate the argument with the provided sentry.

Passing parameters as `sign_up login:login secret:secret` tell Punch to generate `login` and `secret` sentries first, and then validate `login` and `secret` parameters inside constructor.

In `sentries.rb` will be placed two new sentries unless they do not exist.

```ruby
MustbeLogin = Sentry.new(:login, ...
MustbeSecret = Sentry.new(:secret, ...
```

The constructor became

```ruby
def initialize(login:, secret:)
  @login = MustbeLogin.(login)
  @secret = MustbeSecret.(login)
end
```

### "punch entity"

The `$punch entity NAME [PARAM] [PARAM]..` command follows the same principles, but its default template also generates `attr_reader` for parameters. An example follows

```ruby
module Entities
  class User < Entity
    attr_reader :login
    attr_reader :secret

    def initialize(id:, login:, secret:)
      super(id)
      @login = MustbeLogin.(login)
      @secret = MustbeSecret.(ssecret)
    end
  end
end
```

### "punch plugin"

The `punch plugin NAME` command will "punch" Plugin, the command behavior is similar to `punch service/entity`.

### "punch preview"

The `punch preview` command prints the generated code instead of write so you can preview before you punch.

### "punch status"

The `$ punch status` command provides you with basic information about "punched" sources, like how many sources you have punched and how many are still in the wild punched state.

### "punch samples"

You can customize default Punch templates according to your particular purpose. The `$ punch samples` command will copy default templates into your project directory in `.punch` folder. `punch service` and `punch entity` commands will get templates from the `.punch` folder if the folder exists. Those templates are just ERB based on Punch::SentryDecor and Punch::SourceDecor.

### "punch basics"

Punch can provide you with its basic concept classes. The `$ punch basics` command will copy original concepts as follows. Except for Entity, all those classes are the basic concepts that Punch itself designed upon.

```
lib/basics/sentry.rb
lib/basics/entity.rb
lib/basics/service.rb
lib/basics/plugin.rb
lib/basics.rb
```

You can use these as a starter frame and evolve according to your needs.

#### Punch::Sentry

The first Punch primitive is [Sentry](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/sentry.rb) that is a simple module with straight and only purpose - to ensure that argument is valid or raise failure otherwise.

```ruby
ShortString = Sentry.new(:str, "must be String[3..100]"
) {|v| v.is_a?(String) && v.size.between?(3,100)}

ShortString.("string") # => "string"

ShortString.("s")
# => ArgumentError ":str must be String[3..100]"

ShortString.(nil, :name)
# => ArgumentError ":name must be String[3..100]"

ShortString.(nil, 'John Doe', 'Ups!')
# => ArgumentError ":John Doe Ups!"
```

#### Punch::Service

[Service](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/servie.rb)

#### Punch::Entity

[Entity](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/entity.rb)

#### Punch::Plugin

[Plugin](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/plugin.rb)

### "punch domain"

Punch goes a bit further than just a source code generator for services and entities and provides DSL for describing domains of those things.

The `$ punch domain` command copies `domain` folder with a few Ruby sources inside your punched project:

```
sample.rb
domain.rb
dogen.rb
```

Looking through [sample.rb](https://github.com/nvoynov/punch/blob/master/lib/assets/domain/sample.rb) example, you can express your domain and then generate it with `dogen.rb`.

It seems very promising at the moment when besides the code generation you could generate help files,  SRS, interfaces, or whatever you could generate from the domain described in sentries (domain, type), entities, users, and services.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/punch.
