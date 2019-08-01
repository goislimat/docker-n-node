FROM node:8

WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
EXPOSE 3000

ENTRYPOINT [ "./bin/docker_entrypoint.sh" ]