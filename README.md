# Prerequisites

The setups steps expect following tools installed on the system.

- Docker
- Ruby [3.0.4](https://github.com/glenroldan/trust-login-gmo/blob/master/Gemfile#L4)
- Rails [6.1.6](https://github.com/glenroldan/trust-login-gmo/blob/master/Gemfile#L7)

# Getting Started

The application can be built, run and tested using Docker.
It requires `Docker` to be installed.

## Initial setup

```plain
docker-compose build
docker-compose run app bundle exec rails db:setup
docker-compose up
```

To reset/update the database structure and data (for local development only)

```plain
# runs (single) migrations that have not run yet
docker-compose run app bundle exec rails db:migrate

# creates the database
docker-compose run app bundle exec rails db:create

# deletes the database
docker-compose run app bundle exec rails db:drop

# creates tables and columns within the existing database following schema.rb. This will delete existing data.
docker-compose run app bundle exec rails db:schema:load

# does db:create, db:schema:load, db:seed
docker-compose run app bundle exec rails db:setup

# does db:drop, db:setup
docker-compose run app bundle exec rails db:reset

# does db:drop, db:create, db:migrate
docker-compose run app bundle exec rails db:migrate:reset
```

To rollback the migration

```plain
# STEP=(how many step to rollback)
docker-compose exec app bundle exec rails db:rollback STEP=1
```

Getting a shell into the container

`docker ps`

Find the container's ID in the list

`docker exec -it container_id bash`

## Testing

```plain
bundle exec rails spec
```

To use in parallel

```plain
# parallel:spec[CPU_COUNT]
bundle exec rails parallel:spec[2]
```
