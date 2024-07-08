#!/usr/bin/env bash

docker build --build-arg MIX_ENV=prod --build-arg SECRET_KEY_BASE=`mix phx.gen.secret` -t bingo:0.1.0-bld -t bingo:latest .

docker run -p 4000:4000 bingo:latest