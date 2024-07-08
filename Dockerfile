FROM elixir:1.17.1-alpine AS builder

ARG APP_NAME=bingo_umbrella
ENV APP_NAME=${APP_NAME}
ARG APP_VSN=0.1.0
ENV APP_VSN=${APP_VSN}
# The environment to build with
ARG MIX_ENV=prod
# If you are using an umbrella project, you can change this
# argument to the directory the Phoenix app is in so that the assets
# can be built
ARG PHOENIX_SUBDIR=.

ENV MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.hex --force

# This copies our app source code into the build container
COPY . .

RUN mix do deps.get, deps.compile, compile
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
RUN mkdir /dbs 
ENV DB_PATH="bingo_${MIX_ENV}.db"
RUN mix ecto.migrate
RUN mix run apps/bingo/priv/repo/seeds.exs
RUN cp bingo_${MIX_ENV}.db /dbs

# This step builds assets for the Phoenix app (if there is one)
# If you aren't building a Phoenix app, pass `--build-arg SKIP_PHOENIX=true`
# This is mostly here for demonstration purposes

RUN \
  mkdir -p /opt/built && \
  mix release && \
  cp -r _build/${MIX_ENV}/rel/${APP_NAME}/ /opt/built
  
  

# From this line onwards, we're in a new image, which will be the image used in production
FROM elixir:1.17.1-alpine

# The name of your application/release (required)
ARG APP_NAME

RUN apk update && \
    apk add --no-cache \
      bash \
      sqlite \
      openssl-dev

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .
COPY --from=builder /dbs .

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}
ENV DB_PATH="/opt/app/bingo_${MIX_ENV}.db"
CMD ["/opt/app/bingo_umbrella/bin/bingo_umbrella", "start"]