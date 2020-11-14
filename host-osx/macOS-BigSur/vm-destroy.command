#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

VM_NAME="macOS-BigSur"
if [ "`vboxmanage list vms | grep '"'"${VM_NAME}"'"'`" ]; then
    vboxmanage controlvm "${VM_NAME}" poweroff
    vboxmanage unregistervm "${VM_NAME}" --delete
fi
