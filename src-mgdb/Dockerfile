ARG url_docker=docker.io
FROM ${url_docker}/mongodb/mongodb-community-server:7.0.17-ubuntu2204
# FROM ${url_docker}/amd64/mongo:8.0.5-noble

WORKDIR /opt/monogdb_init
COPY init-mongo.js .
