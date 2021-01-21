#!/bin/bash
# Copyright © 2020-2021 Collbow All Rights Reserved

SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

cd "docker"
sed -e "s|\[VOLUME_HOME\]|$(cd "../../" && pwd)/docker-volumes|g" \
	-e "s|\[HOST_NAME\]|$(hostname)|g" "ENV" > ".env"
. ".env"

while read line
do
	if [[ ${line} =~ ^VOLUME_.*$ ]]; then
		dirName=${line#*=}
		mkdir -p "${dirName}"
	fi
done < ".env"

chown -R 1000:1000 "${VOLUME_JENKINS_HOME}"

docker-compose up -d
