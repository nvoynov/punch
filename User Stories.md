% User Stories

As a developer who start a new project ...

# Architecture

I want to design my code base in accord with The Clean Architecture, so it will be easy to write, read, test, and evolve.

# Basic concepts

I want to start as small as possible from PORO domain services by adopting just a few core concepts (Service, Entity, Gateway) so that I will have a clean domain at the beginning. Then as the project goes further I'll get to particular interfaces (CLI, Web, API, Message Broker, etc.)

# Generators

I want to have a few generators for my basic concepts and its tests (entities, services, gateways), that way I'll boost my productivity and reduce mistakes through generating instead of writing manually.

Some sort of Rake tasks?

# Containers

I want to have a basic helpers to start development inside containers (Docker and Compose, Podman, k8s, etc.), that way my development machine will still clear from required technologies like database servers, message brokers, etc.  
