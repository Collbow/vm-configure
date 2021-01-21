#!/bin/bash
# Copyright © 2020-2021 Collbow All Rights Reserved

SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

LOG_FILE="${0%.*}.log"

date "+%Y/%m/%d %H:%M:%S" >> $LOG_FILE

export PATH=$PATH:/usr/local/bin:/usr/bin
if [ -e "${HOME}/.bash_profile" ]; then
    . "${HOME}/.bash_profile"
fi

onShutdown() {
    date "+%Y/%m/%d %H:%M:%S" > $LOG_FILE
    echo "Collbow VMs is Stopping." >> $LOG_FILE
    vagrant halt >> $LOG_FILE
    echo "Collbow VMs is stopped." >> $LOG_FILE
    osascript -e 'display notification "Collbow VMs is stopped." with title "Collbow VMs"'
    exit
}

echo "Collbow VMs is starting." >> $LOG_FILE
vagrant up >> $LOG_FILE
echo "Collbow VMs is started." >> $LOG_FILE
osascript -e 'display notification "Collbow VMs is started." with title "Collbow VMs"'

trap 'onShutdown' SIGHUP SIGINT SIGQUIT SIGTERM

while true; do
    sleep 86400 & wait $!
done
