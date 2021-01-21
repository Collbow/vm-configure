#!/bin/bash
# Copyright © 2020-2021 Collbow All Rights Reserved

SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

exec &>>(tee "${0}.log")
date "+%Y/%m/%d %H:%M:%S"

# Directory to store vagrant box and virtual machine
VM_BASE_DIR=$(cd "${SCRIPT_DIR}/../" && pwd)

# # --------------------------------------------------
# # Change the save destination of vagrant box files to the VM_BASE_DIR folder.
# # If you don't want to change the save folder, please comment out.
# if [ -e "${HOME}/.bash_profile" ]; then
#     sed -i _cb.bak -e "/^export VAGRANT_HOME=.*$/d" "${HOME}/.bash_profile"
#     rm "${HOME}/.bash_profile_cb.bak"
# fi
# echo 'export VAGRANT_HOME="'"${VM_BASE_DIR}"'/.vagrant.d"' >>"${HOME}/.bash_profile"
# # --------------------------------------------------

# # --------------------------------------------------
# # Change the save destination of vagrant box files to the VM_BASE_DIR folder.
# # If you don't want to change the save folder, please comment out.
# vboxmanage setproperty machinefolder "${VM_BASE_DIR}/VirtualBox VMs"
# # --------------------------------------------------

if [ -e "${HOME}/.bash_profile" ]; then
    . "${HOME}/.bash_profile"
fi

vagrant init
vagrant up

chmod u+x com.collbow.vagrant.sh
sed 's|\[SCRIPT_DIR\]|'"${SCRIPT_DIR}"'|g' "com.collbow.vagrant.plist" > "${HOME}/Library/LaunchAgents/com.collbow.vagrant.plist"
launchctl load "${HOME}/Library/LaunchAgents/com.collbow.vagrant.plist"
launchctl start com.collbow.vagrant