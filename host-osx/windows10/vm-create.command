#!/bin/bash
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

if [ ! "`vagrant plugin list | grep 'vagrant-reload'`" ]; then
    vagrant plugin install vagrant-reload
fi

if [ ! "`vagrant box list | grep 'Microsoft/EdgeOnWindows10'`" ]; then
    unzip MSEdge.Win10.Vagrant.zip
    vagrant box add "./MSEdge - Win10.box" --name "Microsoft/EdgeOnWindows10"
    rm "./MSEdge - Win10.box"
fi

vagrant init
vagrant up
