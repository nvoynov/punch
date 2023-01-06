% Punch2

# TODO

sentry
entity
service
command
usecase
domain
source
extras
basics

- [ ] `punch dsl/domain` or separate script `dogen DSL`
- [ ] `punch plugin`, maybe the next version
- [ ] `punch extra`, maybe the next version
- [ ] manual exe/punch tests
- [ ] README
- [ ] replace origin Punch
- [ ] punch plugin?
- [ ] storage, hash_storage, sequel_storage highlight CQRS and Command-layer

# Orders Service Demo

- Punch DSL for Orders Domain
- Orders Service on Sinatra
  Articles In Another service!! only order for customer and Manager
  updating articles from events!
  - signup/signin place sessions somewhere dRuby?
  - orders service receive token from dRuby and check it for dRuby

Entities:

- Feature(name)
- Role(name, features)
- User(email, name, roles)
- Credentials(email, secret)
- Article(name, price, description)
- OrderItem(article, order, price, quantity)
- Order(user, created_at, status, status_at, status_by, order_items)

User:

- signup
- signin (session, then session checks user.admin? but it is UI layer)
- change_password

Admin:

- list of users
- lock
- unlock
- grant role?

Manager

- list of articles
- create article
- change article
- remove article
- list of orders
- approve order
- cancel order

Customer

- list of articles
- list of my orders
- create order
- change order
