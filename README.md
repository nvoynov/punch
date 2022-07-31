# Punch

The Punch is a source code generator based on [Clean](https://github.com/nvoynov/clean) that was born to boost productivity by generating source and test files instead of writing in manually. You can look through [User Stories](UserStories.md) for its basic ideas.

Punch also plays for Clean as some kind promoter and varnisher - 1) it is an example of direct utilizing Clean, and 2) it is the first user who gives feedback. And it's a bit tricky, but you can find some explanations of Punch code inside [Clean Readme](https://github.com/nvoynov/clean/blob/master/README.md)

Keep code clean, and happy punching!

## Installation

I'm still not push it to rubygems.org, so it should be installed manually

    $ git clone https://github.com/nvoynov/punch.git
    $ cd punch
    $ bundle
    $ rake install

Then you can add this line to your application's Gemfile:

```ruby
gem "punch", "~> 0.2.0", git: "https://github.com/nvoynov/punch.git"
```

And then execute:

    $ bundle install

Or you can just start punching and "punch" Gemfile :)

    $ punch new some_app

## Usage

Run `$ punch` to see its banner and get the basics

### Punching projects

To "punch" a new project run the following command

    $ punch new PROJECT

the command will create the following project structure

    <project>
    <project>/Gemfile
    <project>/Rakefile
    <project>/test
    <project>/test/test_helper

You can also start "punching" inside an empty directory

    $ mkdir punch_demo
    $ cd punch_demo
    $ punch init

and it will do actually the same as `$ punch punch_demo` except creating a directory

### Preview "in action"

Instead of describing the Punch commands, I would recommend trying them "in action" right away. Just run a few of the examples provided in the `$ punch` output through `punch preview <command> <params>`. This `preview` command reads punched directory and writes created content to STDOUT but does not change files.

### Punching sources

There are only two basic punching commands - `punch service` and `punch entity`. And these will create/replace sources based on templates that can be found in `lib/assets/erb`. But I think you already got it punching previews.

It needs to be pointed out that there is one problem with templates that is about "where can I get my basic concept to inherit?" where I can guess a few possible strategies - 1) basic concepts are in a separate directory like `lib/gadgets`; 2) in the same directory as for descendants like `lib/services/service.rb` and `lib/services/create_user.rb`; and 3) it is inherited just form `Clean::Service`.

Current templates just use the second option but I prefer to create a project-specific service because there is always project-specific something that could be included (see my [service.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/services/service.rb).)

### Configuration

Punch can be configured a bit through `punch.yml` that actually points directory paths to write sources.

```yaml
--- !ruby/object:Punch::Config
lib: lib
test: test
sentries: sentries
entities: entities
services: services
```

You can interpret it as "services will be placed to lib/services directory and its tests to test/services". So you can change it for `lib: app` and the service will be placed in "app/services/"

### Logging

The last thing is logger. Punch logs commands and possible exceptions inside `punch.log`

## History

This gem stands on the shoulders of [Cleon](https://github.com/nvoynov/cleon) and [Dogen](https://github.com/nvoynov/dogen), developing and systematizing their ideas, even grabbing some of their source code.

As for [Cleon](https://github.com/nvoynov/cleon), firstly, I am confused that it sort of breaks the SRP by being responsible for both data (basics sources) and behavior (code generation). Secondly, it is slightly over-engineered being requiring working folder with gem.

As for [Dogen](https://github.com/nvoynov/dogen), being a really curious idea by adding DSL, it still remains a code generator.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and questions are welcome on GitHub at https://github.com/nvoynov/punch.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
