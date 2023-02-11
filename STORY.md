---
title: Punch Story
date: 2023-01-26
...

The Punch story began somewhere in November 2021 when I got the feeling that playing Business Analyst last ten years, I lost the reality of modern software design and construction, and to dispel that feeling so took some time off to refresh my expertise in the subject.

I was interested in distributed systems, message brokers, event-sourcing, CQRS, etc. so decided to go for the distributed back-end of microservices. But before touching techs there, I intended to have _"clean" and "screaming"_ microservices and started with just the business logic layer.

### Cleon and Dogen

Enforced with The Clean Architecture I build _Cleon Gem_, which gave me the basic frame of services, entities, and gateways. Tired of manually copying sources for the next app, I added a simple CLI to clone the frame into a new gem where I was supposed to design the business logic of the app further.

Further being curious about the idea of code generation, I created a simple DSL for describing domains in terms of services and entities. This idea was shaped into Dogen Gem (domain generator.) and my new flow became 1) describe the domain, 2) generate domain skeleton sources, and finally 3) design business logic manually inside created and required sources. So at this stage, Cleon provided me with core concepts of services and entities, whereas Dogen provided me with domain DSL and code generation. I was pretty happy with that two.

### Reality Check

I got a probation period in a development company and one of the reasons why they looked to my side was my Cleon gem. The company team worked with bare applications and the idea of packing business logic into gems seemed just extraneous to them. And now I am also curious why I added this constraint at all :)

It was quite an exciting time when I finally saw a few real microservice codebases and API Gateway, played a bit with Docker, tried development in containers, and met RabbitMQ... but it was not the right place for me.

### Modern Punch

By the impact of and during that probation period, I designed [Punch](https://github.com/nvoynov/punch) that replaced Cleon and eliminated that extraneous constraint of having Gem.

Finished with redesigning Clerq into Marko, at the beginning of 2023 I merged Dogen into Punch. Having played with it for a few weeks I can say that my next app will start from `$ punch new` and the following step will be designing the domain with DSL.
