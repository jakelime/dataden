ARG url_docker=docker.io
ARG PGDB_PORT=23501
FROM ${url_docker}/postgres:17.2-alpine

WORKDIR /opt/pgworkdir
COPY . .
RUN bash write_pg_init.sh
RUN rm .env

