#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

if [ -e "${HOME}/.bash_profile" ]; then
    . "${HOME}/.bash_profile"
fi

exec &>>(tee "${0}.log")
date "+%Y/%m/%d %H:%M:%S"

vagrant halt
vagrant destroy
