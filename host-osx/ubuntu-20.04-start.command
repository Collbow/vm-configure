#!/bin/bash
# Copyright © 2020-2021 Collbow All Rights Reserved

SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

if [ -e "${HOME}/.bash_profile" ]; then
    . "${HOME}/.bash_profile"
fi

launchctl start com.collbow.vagrant
