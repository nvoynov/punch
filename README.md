# Punch

The Punch's basic idea is to provide a clean robust frame for domain business logic and bring efficiency to the design process.

Playing last year with [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) I found it just a really amazing tool, but it also was a bit tiresome because of the necessity to create and require entities and services sources separately. That's why I designed Punch, which provides:  

- three basic blocks - entity, service, and plugin
- source code templates for those blocks
- command-line interface for punching those blocks
- simple domain DSL to express and "punch" domains

You can find an example of a "punched" domain in [punch_users](https://github.com/nvoynov/punch_users.git) repository.

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

Punch can be configured through `punch.yml` file that can be found inside your punch project. One can point out directories for punching based on a particular concept. The default settings are:

```yml
lib: lib
test: test
domain:
sentries: sentries
entities: entities
services: services
plugins: plugins
```

In accordance with these settings `Punch` will generate code inside `lib` and tests inside `test`. [Sentries](#sentry) will be punched into `lib/sentries.rb`, entities and services respectively into `lib/entities` and `lib/services`; concepts namespaces will be `Entities`, `Services`, and `Plugins`

When you change `domain` settings as `domain: domain`, code will be placed to `lib/domain`. Assuming running the `$ punch service sign_in email password` command Punch will generate

- `lib/domain/services/sing_in.rb`
- `lib/domain/services.rb~` (require "services/sign_in")
- `test/domain/services/test_sing_in.rb`  
- `Domain::Services` will be the service namespace

You can go even further and run `$ punch service user/sign_in email password` and it this case if will affect output as:

- `lib/domain/services/user/sing_in.rb`
- `lib/domain/services/user.rb~` (require "user/sign_in")
- `test/domain/services/user/test_sing_in.rb`  
- `Domain::Services::User` will be the service namespace

### "punch service"

The `$ punch service NAME [PARM] [PARAM] ...` command will punch a new service- and its test into your "punched" project. Code will be generated only when the current folder contains `punch.yml`.

The output of the command will be the list of created or modified source files by the command. It is safe enough to prevent you from losing important changes inside punched sources. So when you "punched" some source and then "re-punch" the same concept again, Punch will check was the content changed from its punched state. The command will be aborted for changed content, or the previous copy will be backed for "wild-punched" content.

When you run something like `$punch service sign_up login password`, Punch will generate code according with service template, something like follows

```ruby
module Services
  class SignUp < Service
    def initialize(login, password)
      @login = login
      @password = password
    end

    def call
    end
  end
end
```

The `login` and `password` parameters there could be passed in a few ways and the chosen way will affect for code generation output.

1. Finishing parameters with `:` will tell the Punch to generate keyword arguments, so `sign_up login: password:` will generate constructor declaration as `def initialize(login:, password:)`
2. Providing default values for parameters like `sign_up "login \"user\"" "password \"$ecret\""` will generate `def initialize(login = "user", password = "$ecret")`
3. In the same manner you can provided default values for keyword arguments - `sign_up "login: \"user\"" "password: \"$ecret\""` will generate `def initialize(login: "user", password: "$ecret")`
4. Positional and keyword arguments can be mixed together. Punch is advanced enough to place it into right order - positional first, positional with default values next, and keywords at the end.

And finally we can meet the [Sentry](#sentry). For keyword arguments you can point a sentry, and being pointed for an argument, constructor will validate the argument with the provided sentry.

Passing parameters as `sign_up login:login password:password` tell Punch to generate `login` and `password` sentries first, and then validate `login` and `secret` parameters inside constructor.

In `sentries.rb` will be placed two new sentries unless they do not exist.

```ruby
MustbeLogin = Sentry.new(:login, ...
MustbePassword = Sentry.new(:secret, ...
```

The constructor became

```ruby
def initialize(login:, password:)
  @login = MustbeLogin.(login)
  @secret = MustbePassword.(password)
end
```

### "punch entity"

The `$punch entity NAME [PARAM] [PARAM]..` command follows the same principles, but its default template also generates `attr_reader` for parameters. An example follows

```ruby
module Entities
  class User < Entity
    attr_reader :login
    attr_reader :secret

    def initialize(id:, login:, password:)
      super(id)
      @login = MustbeLogin.(login)
      @secret = MustbePassword.(password)
    end
  end
end
```

### "punch plugin"

The `punch plugin NAME` command will "punch" Plugin, the command behavior is similar to `punch service/entity`. In addition it will create `config.rb` file with Plugin::Holders placed there.

### "punch preview"

The `punch preview` command prints the generated code instead of write so you can preview before you punch.

### "punch status"

The `$ punch status` command provides you with basic information about "punched" sources, like how many sources you have punched and how many are still in the wild punched state.

### "punch samples"

You can customize default Punch templates according to your particular purpose. The `$ punch samples` command will copy default templates into your project in `.punch/samples` folder and Punch will get templates from there. Those templates are just ERB based on Punch::SentryDecor and Punch::SourceDecor.

### "punch basics"

Punch can provide you with its own basic concept it itself designed upon. The `$ punch basics` command will copy sources as follows. You can use those as a starter and evolve according to your needs.

```
lib/punch/basics/sentry.rb
lib/punch/basics/entity.rb
lib/punch/basics/service.rb
lib/punch/basics/plugin.rb
lib/punch/basics.rb
lib/punch.rb
```

#### Punch::Sentry

[Sentry](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/sentry.rb) that is a simple module with straight and only purpose - to ensure that argument is valid or raise failure otherwise.

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

[Service](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/servie.rb) is very basic class with `call` method with the idea to do the job and return the result or fail.

```ruby
class SingIn < Service
  def intitialize(login, password)
    @login = login
    @password = password
  end

  def call
    user = storage.get(User, login: @login)
    failure("Wrong login or password") unless user
    failure("Wrong login or password") unless user.password == password
    user
  end
end
```

You can provide your own templates and basic concepts if it does not fit your expectations

#### Punch::Entity

[Entity](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/entity.rb) is just minimal entity class with `id` attribute that passed nil becomes `SecureRandom.uuid`

You might work with ActiveRecord or other models instead of just plain entities, and in this case you can also provide your own model and test templates and even change `entities: enttities` into `entities: model`. That way you calling `$ punch entity user` you'll get

- `lib/domain/models/user.rb`
- `test/domain/models/test_user.rb`

#### Punch::Plugin

[Plugin](https://github.com/nvoynov/punch/blob/master/lib/punch/basics/plugin.rb) is a simple mixin for your plugin interfaces (implementations external to the domain) and when you have dependent services you can write something like

```ruby
require "forwardable"
require "basics"
require "config"

class UserSignUp < Service
  extend Forwardable
  def_delegator :StorageHolder, :object, :storage
  def_delegator :SecretsHolder, :object, :secrets
 # skipped ..
end
```

### "punch domain"

Punch goes a bit further than just a source code generator for services an d entities and provides DSL for describing domains of those things.

The `$ punch domain` command create `.punch/domain` folder with a few Ruby sources inside your punched project:

```
sample.rb
domain.rb
dogen.rb
README.md
```

Looking through [sample.rb](https://github.com/nvoynov/punch/blob/master/lib/assets/domain/sample.rb), you can express your domain and then generate it with `dogen.rb` script.

It seems very promising at the moment when besides the code generation you could generate help files, SRS, interfaces, or whatever you could generate from the domain described in sentries (domain, type), entities, users, and services.

For the example, writing requirements I always elaborate on "Use Cases" and "Entities" sections of SRS, so my SRS can be easily expressed by the `Punch::DSL`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/punch.
