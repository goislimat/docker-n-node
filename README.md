# DOCKER SETUP PROPOSAL

Suggested setup for a project running on top of Docker containers. This example was built with node and requires:

- **[NodeJS](https://nodejs.org/en/download/)**
- **[Docker](https://docs.docker.com/install/)**

## Getting Started

Clone the project and `cd` into it:

```bash
git clone git@github.com:goislimat/docker-n-node.git && cd docker-n-node
```

Then you're able to run the project with docker using:

```bash
sh ./bin/docker_setup.sh
```

The `docker-compose.yml` file is mapping the port `3000` inside the container into the `80` on host. So all you have to do for testing if everything is working is

```bash
curl localhost
```

and you may see a `Hello World!` message from express. As an option, you should be able to see the same message if you navigate to `http://localhost`.

## Developing

After the installation proccess, everytime you need to develop a new feature for this project, all you have to do is

```bash
docker-compose up
```

and start coding.

## Testing

The docker container is configured to run all your tests using a simple:

```bash
docker-compose run web test
```

This command will run `jest` and test all the files inside your project.

## What's happening behind the scenes?

We have 4 main files that ensure this project will work with Docker.

- `Dockerfile`
- `docker-compose.yml`
- `./bin/docker_setup.sh`
- `./bin/docker_entrypoint.sh`

#### Dockerfile

```docker
# Bring the official node 8 image from docker hub
FROM node:8

# Create the app folder alongside with node_modules
# and give permission to node user
RUN mkdir -p /home/node/app/node_modules && \
    chown -R node:node /home/node/app
# cd into /home/node/app folder
WORKDIR /home/node/app
# Copy the package.json and package-lock files into the current
# directory
COPY package*.json ./
# Switches to node user
USER node
# Install the dependencies
RUN npm install
# Copy every file from the host to the container /home/node/app
# folder giving permission to node user
COPY --chown=node:node . .
# Expose the 3000 port
EXPOSE 3000

# Execute docker_entrypoint script
ENTRYPOINT [ "./bin/docker_entrypoint.sh" ]
```

#### docker-compose.yml

```yml
version: "3"
services:
  # Create a service with the name of web
  web:
    # Build using the Dockerfile from this directory
    build: .
    # Map the port 3000 from the container to respond at
    # port 80 on host
    ports:
      - "80:3000"
    # Sync the data from the current directory into the host
    # with the /home/node/app into the container
    volumes:
      - .:/home/node/app
    # Executes the npm start command inside the container
    command: ["npm", "start"]
```

#### ./bin/docker_setup.sh

```bash
#!/bin/bash -e

# Test if the user has docker-compose installed
echo "=== Starting project setup for docker development environment ==="
if ! command -v 'docker-compose' > /dev/null; then
  echo "Docker Compose not installed. Install before continue."
  exit 1
fi

# Install packages locally so it can be mapped via volumes on
# docker-compose.yml file
echo "=== Installing node packages ==="
npm install

# Build project
echo "=== Building node-test project ==="
docker-compose build web

# Execute project
echo "=== Running node-test project ==="
docker-compose up

echo "=== Setup finished ==="
```

#### ./bin/docker_entrypoint.sh

```bash
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
```

#### How those pieces work togheter?

When you first run

```bash
sh ./bin/docker_setup.sh
```

you install the dependencies, build the `web` container and bring it up.

When you build it, every step described on the `Dockerfile` is executed, and you can see the image created with

```bash
docker image ls
```

and if you follow the exact steps listed here, the repository name should be `node-n-docker_web`.

When you bring the container up, the ports and volumes are mapped, and the `npm start` command is executed.

And when you want to test, running

```bash
docker-compose run web test
```

another container is booted executing the test inside it. And if you have any other proccess that you wanted to automate, you should be able just by adding it into the `case "$COMMAND"` statement. As a bonus, you are also able to run any non automated command because of the default (`*)`) statement of this `case`.
