# Bingo

This is an implementation of this [engineering-assessment](https://github.com/peck/engineering-assessment/blob/main/README.md).

# What does this service do?

This service, Bingo, creates bingo cards which can be used as a way to find food trucks and also be a game among teammates.

Eat your way through all the food trucks with Bingo!

# How do I setup, test, build this service?

## Setup

### Prerequisites

- [asdf](https://asdf-vm.com/), with the [asdf-elixir](https://github.com/asdf-vm/asdf-elixir) and [asdf-erlang](https://github.com/asdf-vm/asdf-erlang) plugins (`/.tool-versions` enforces exlixir and erlang versions)
- [docker](https://docs.docker.com/get-docker/)

### Compile

```
mix local.hex
mix deps.get
mix compile
```

### Run tests

```
mix test
```

### Run locally

```
# Run migrations, populate with data
mix ecto.migrate
mix run apps/bingo/priv/repo/seeds.exs
mix phx.server # go to http://localhost:4000/
```

### Run with docker

```
# Runs server on http://localhost:4000/
./docker_up.sh
```

### TODO: DEPLOY

Here, I'd imagine that we'd have CICD to build a prod docker image, push it to dockerhub, and then update the deploys.

### TODO: Links to logs, metrics dashboards, runbooks

Charity Majors, in Observability Engineering, said that in an observable system the most curious developer, not the developer that made the system, is the best debugger.  Logs, metrics, and runbooks help a curious (and oncall) dev thrive.  But its not done here because this is a take home.

## Architectural choices

(There should be an ADR directory so that a history of design choices can be maintained, but for a take home, it seemed unnecessary)

- Prioritize simple releases with an eye to the future: The faster we can test the hypothesis of "is this useful," the better off we'll be.  With that in mind, I opted to create a static cache of food trucks and let the app use that as a datastore.  Deployments are simple, and there is no other team dependencies (assuming that we have access to deployment infra, but that we'd need other teams to setup test and prod DBs) as everything lives in a single docker container.  
- Using SQLite was chosen deliberately:  Given the use case (return a random set), the app only requires reading data.  Furthermore, the CSV is small in size (600+ records is <2MB in size).  So even if there was 10x the number of food trucks in the CSV, that number can still fit in memory.  The app uses Ecto, so even though the current DB is a staic one, It will be easier to switch to a mysql/postgres if the business need comes.
- Scaling can be done by spinning up more docker containers:  Since DBs are usually the bottleneck in services, an advantage of having a DB in memory of the service is that if the service is too popular, we can support more load by running more docker containers behind a load balancer
- I created an umbrella project because even though the current functionality is simple, as new functionality is needed we can break them into subapps.  E.g. authorization/authentication could be a subapp.
- I used phoenix because it is a common framework.  I created it with defaults (live reload, pubsub, etc).  so it adds some complexity to the code, but also provides for future development.
- TODO: logging.  I'd use [open telemetry](https://opentelemetry.io/docs/languages/erlang/) for logging bc it is a common framework which makes it easier to have observable services.