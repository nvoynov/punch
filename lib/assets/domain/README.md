% Punching Domains

Having described your domain by using Punch::DSL, you can easily generate lots more things than just Ruby code. It might fit perfectly for generating domain documentation, sketching future domain interfaces, etc.

The following examples were born during [punch_orders](https://github.com/nvoynov/punch_orders) project:

- `fagen.rb` generate some general interface code for developing domain interface (service proxy, action, presenter, face);
- `ragen.rb` generates actions for domain services;
- `marko.rb` generates requirements for [Marko](https://github.com/nvoynov/marko) project.

Change `domain` setting in `punch.yml` in appropriate domain name, when you want a separate namespace for the domain.
