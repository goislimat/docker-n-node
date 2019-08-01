#!/bin/sh

set -e

# Captures the command passed as an argument on
# docker-compose run <service> <params>
# e.g. docker-compose run web test
COMMAND="$1"

# Defines what should be executed based on the passed command
case "$COMMAND" in
  test)
    echo "=== Trigerring Jest ==="
    npm test
    ;;
  *)
    echo "=== Running command $*"
    sh -c "$*"
    ;;
esac