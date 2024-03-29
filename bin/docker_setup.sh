#!/bin/bash -e

# Test if the user has docker compose installed
echo "=== Starting project setup for docker development environment ==="
if ! command -v 'docker-compose' > /dev/null; then
  echo "Docker Compose not installed. Install before continue."
  exit 1
fi

# Give permissions to execute the docker_entrypoint file
chmod +x ./bin/docker_entrypoint.sh

# Build the project
echo "=== Building node-test project ==="
docker-compose build web

# Executes the project
echo "=== Running node-test project ==="
docker-compose up

echo "=== Setup finished ==="