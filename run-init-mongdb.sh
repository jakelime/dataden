#!/bin/bash
# this script is meant to be run on a windows host
# machine with WSL, to initialise MongoDB database

source loader_library.sh
load_env_file .env

echo "MONGODB_PORT is ${MONGODB_PORT}"
echo "initialising first mongdb container..."
docker compose run --name mgdb -d --publish ${MONGODB_PORT}:${MONGODB_PORT} --rm mgdb
echo "removing mongdb container(step1)..."
docker container rm mgdb -f
sleep 8s
# current_dirpath="$(pwd)"
sudo mkdir -p /var/data/mongodb
echo "fixing permissions from persistent disk..."
sudo chmod -R 777 /var/data/mongodb
# cd $current_dirpath
echo "initialising 2nd mongdb container without auth..."
docker compose run --name mgdb -d --publish ${MONGODB_PORT}:${MONGODB_PORT} --rm --entrypoint "mongod --bind_ip 0.0.0.0 --port ${MONGODB_PORT}" mgdb
sleep 5s
echo "executing database init..."
docker exec mgdb bash -c "mongosh init-mongo.js --port ${MONGODB_PORT}"
echo "removing throwaway mongodb containers..."
docker container rm mgdb -f
sleep 8s
echo "composing final mgdb container ..."
docker compose up -d mgdb --build
