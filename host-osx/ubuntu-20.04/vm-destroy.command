#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

if [ -e "${HOME}/.bash_profile" ]; then
    . "${HOME}/.bash_profile"
fi

exec &>>(tee "${0}.log")
date "+%Y/%m/%d %H:%M:%S"

launchctl unload "${HOME}/Library/LaunchAgents/com.collbow.vagrant.plist"
rm -f "${HOME}/Library/LaunchAgents/com.collbow.vagrant.plist"

vagrant destroy
