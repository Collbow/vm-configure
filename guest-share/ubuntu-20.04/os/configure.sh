#!/bin/bash
# Copyright © 2020-2021 Collbow All Rights Reserved

SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

echo "$SCRIPT_DIR"
. "env.conf"

apt dist-upgrade

apt-get remove -y docker docker-engine docker.io containerd runc
apt-get update -y 
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

LF=$'\n'
sysctl=`cat "/etc/sysctl.conf"`
while read line
do
	sysctl=`echo "${sysctl}" | sed -e "/^${line%%=*}=.*$/d"`
	sysctl+="${LF}${line}"
done < "sysctl.conf"
echo "${sysctl}" > "/etc/sysctl.conf"
sysctl -p

hostnamectl set-hostname $HOST_NAME
