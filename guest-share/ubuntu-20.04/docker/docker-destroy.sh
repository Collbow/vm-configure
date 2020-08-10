#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

docker-compose stop

docker system prune
echo "y" | docker image prune
echo "y" | docker volume prune
echo "y" | docker network prune

echo "y" | docker rmi `docker images -q`
echo "y" | docker volume rm `docker volume ls -q`
echo "y" | docker network rm `docker network ls -q`

rm -r ../../docker-volumes
