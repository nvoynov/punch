---
title: Punch Introduction
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

# Intro

Playing with [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) in 2021 I found it just an amazing tool, but a bit tiresome also because of the necessity to constantly create and require a bunch of template classes like entities and services. That was the reason for designing Punch. I wanted just a few things

1. Design my code base by The Clean Architecture principles, so it will be easy to write, read, test, and evolve.
2. Start as small as possible with just PORO by adopting services, entities, and plugins, postponing particular technologies as much as possible (CLI, Web, Message Brokers, Storage, etc.)
3. Punch (generate) services, entities, and plugins to boost productivity and reduce mistakes by generating them instead of writing manually.

Punch provides a few basic stuff:

1. Four basic concepts - Service, Entity, Plugin, Sentry
2. source code templates for the concepts
3. CLI for punching the concepts
4. DSL to express and "punch" the domain of the concepts

# Basics

## Service

The crucial part and the face of any domain is a set of actors (users) and services (use cases, interactors) provided by the domain to the actors. This part "screams" about the domain intent.

Punch provides you with its own [basic service](lib/punch/basics/service.rb) that is used across the Punch itself for punching concepts.

Regular domain service operates with business entities and other environment-provided stuff using plugins. The service is also considered the domain boundary and must guard the domain against wrong incoming data. My basic domain service in 99% cases looks like this:

```ruby
require_relative '../basics'
require_relative '../plugins'
require_relative '../sentries'
require_relative '../entities'
require 'forwardable'

# Basic Domain Service
class Service < Punch::Service
  include Entities
  extend Forwardable
  def_delegator :PluginHolder, :object, :plugin
end
```

The basic service will be utilized by a regular service like this:

```ruby
require_relative 'service'

class CreateOrder < Service
  def initialize(user_id:)
    @user_id = MustbeUUID.(user_id, :user_id)
  end

  # @return [Order]
  def call
    user = store.get(User, id: @user_id)
    fail Failure, 'unknown user' unless user
    order = Order.new(user_id: @user_id)
    store.put(order)
  end
end
```

Depending on domain purpose, it could operate with value objects instead of entities. It is exactly the Punch case that does not operate with any business data but uses value objects placed under Punch::Models namespace.

The good name for a domain service will include actor and action, consider names like UserCreateOrder, ManagerRejectOrder, SystemNotifyParties, etc.

## Entity

The Entity represents some data record and the simplest (even "native") way to express such records is to use the regular Ruby 3.2 Data class

```ruby
class Order < Data.define(:id, :created_at, :created_by)
  def initialize(id: SecureRandom.uuid, created_at: Time.now, created_by:)
    super
  end
end
```

And it is the point where the first reflection appears - should the entity guard constructor arguments or it is the responsibility of the appropriate service that creates the entity.

In regular user applications, usual flow will be the following:

1. The actor requests the service, passing required parameters
2. The service creates the entity and returns it to the actor.

In such cases, the native way will be the service that guards parameters

```ruby
class CreateOrder < Service
  def initialize(user_id:)
    @user_id = MustbeUUID.(user_id, :user_id)
  end

  def call
    order = Order.new(created_by: @user_id)
    store.put(order)
  end
end  
```

When one deals mainly with complex value objects (models, data without identity), maybe it will be more suitable to guard model parameters in the constructor of the model

```ruby
class Param < Data.define(:name, :type, :desc)
  def initialize(name:, type:, desc: '')
    MustbeStrOrSym.(name, :name)
    MustbeStrOrSym.(type, :type)
    MustbeStrOrSym.(desc, :desc)
    super
  end
end

MustbeParamCollection = Sentry.new(:params, 'must be Array<Param>'
) {|v| v.is_a?(Array) && v.all?{|e| e.is_a?(Param)} }

class Model < Data.define(:name, :params, :desc)
  def initialize(name:, params:, desc: '')
    MustbeStrOrSym.(name, :name)
    MustbeStrOrSym.(desc, :desc)
    MustbeParamCollection.(params)
    super
  end
end
```

## Plugin

A plugin represents an interface to the world outside the domain. The real world consists of database servers, file storages, message brokers, etc. But the interface should be tied to the domain, not to the tech beside the real world.

Assuming that domain entities are stored inside some data store, one could sketch the simples store interface like follows:

```ruby
class Store
  extend Plugin

  # @param klass [Class]
  # @param criteria [Hash]
  # @return [Object] first :klass object matched to :criteria or nil when not found
  def get(klass, **criteria)
    fail "#{self.class}#get must be overridden"
  end

  # @param obj [Object]
  # @return [Object] put object
  def put(obj)
    fail "#{self.class}#get must be overridden"
  end
end  
```

To bring plugins to the domain services Punch provides "plugins.rb"

```ruby
 require_relative 'plugins/store'
 StoreHolder = Store.plugin
```

At the domain development stage there is no necessity to have and even choose real tech behind the interface - the good practice to mock and stub the real world for testing purpose (minitest examples of using mock provided inside generated tests).

## Sentry

The sentry is a little helper to guard the domain against wrong input data. Domain services and entities usually share a bunch of data primitives like UUID, email, string 256, positive integer no more than 100, etc.

The example of utilizing sentries placed above in [Entity](#entity) section.

```ruby
MustbeParamCollection = Sentry.new(:params, 'must be Array<Param>'
) {|v| v.is_a?(Array) && v.all?{|e| e.is_a?(Param)} }
```

# App Design

When one have working clean domain of services, entities, and plugins the application design becomes just tech adoption and configuration stuff. Basically, one need

1. Provide the user interface layer (CLI, Web, API, Message Broker, etc.)
2. Implement plugin interfaces for chosen technologies (database, external API, etc.)
3. Configure the app by assembling the app interface, services, and plugin implementation

Some first preliminary numbers shows that my apps is something about 700 SLOC Ruby with blanks and comments. And important thing is it won't grow further when domain grows.

# Examination

At this time I've "punched" a few simple domains and saw some statistics at the beginning and at the end of the project (the `punch stat` command was provided especially for the need)

[The very first demo]{.underline} repo [punch_users](https://github.com/nvoynov/punch_users.git) (just domain without app) shows:

- 85% of sources were "punched" and 15% were created manually;
- 50% of Ruby LOC were "punched" and the other 50% were created manually.

Location   Total   "Punched" SLOC       Blank    Comments  Net Ruby LOC
---------- ------- --------- ---------- -------- --------- ------------
lib        23 (17) 13 (13)   657 (329)  102 (53) 175 (93)  380 (183)
test       17 (17) 15 (16)   363 (335)  46 (38)  45 (150)  272 (147)
lib + test 40 (34) 28 (29)   1020 (664) 148 (91) 220 (243) 652 (330)

[The next demo]{.underline} repo []() with a few app interfaces and plugins

[One of the real project]{.underline} statistics .. unfortunately have no stat just after punching domain

"scc app" shows how small the app really is (3200 for domain and 700 for app!)

```
Language                 Files     Lines   Blanks  Comments     Code Complexity
───────────────────────────────────────────────────────────────────────────────
Ruby                         9       710       82       124      504         35
```

punch status a bit polluted test by tech plugins test

```
Looking through 'lib', 'test' directories..

- 85 sources, 52 "punched" (4 remain "punched")
- 3178 SLOC, 458 blank and 617 comment lines

'lib' summary:
- 39 sources, 25 "punched" (0 remain "punched")
- 1349 SLOC, with 198 blank lines and 413 comments

'test' summary:
- 46 sources, 27 "punched" (4 remain "punched")
- 1829 SLOC, with 260 blank lines and 204 comments

remain "punched":
- test/ba.../entities/test_device.rb
- test/ba.../entities/test_target.rb
- test/ba.../services/test_user_query_drivers.rb
- test/ba.../services/test_user_query_targets.rb
```
