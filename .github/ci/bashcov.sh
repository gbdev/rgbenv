#!/usr/bin/env bash

bashcov -- /rgbenv/bats/bin/bats tests

cat coverage/lcov/rgbenv.lcov | grep ",0"
