#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

if [ ! -e "${SCRIPT_DIR}/BigSur.iso" ]; then
    if [ ! -e "/Applications/Install macOS Big Sur.app" ]; then
        softwareupdate --fetch-full-installer --full-installer-version 11.0.1
    fi

    hdiutil create -o "${SCRIPT_DIR}/BigSur" -size 16G -layout SPUD -fs HFS+J -type SPARSE -volname BigSur
    hdiutil attach "${SCRIPT_DIR}/BigSur.sparseimage" -noverify -mountpoint "/Volumes/BigSur"
    sudo "/Applications/Install macOS Big Sur.app/Contents/Resources/createinstallmedia" --volume "/Volumes/BigSur" --nointeraction
    hdiutil detach "/volumes/Shared Support"
    hdiutil detach "/volumes/Shared Support 1"
    hdiutil detach "/volumes/Install macOS Big Sur"
    hdiutil convert "${SCRIPT_DIR}/BigSur.sparseimage" -format UDTO -o "${SCRIPT_DIR}/BigSur.cdr"
    mv "${SCRIPT_DIR}/BigSur.cdr" "${SCRIPT_DIR}/BigSur.iso"
    rm "${SCRIPT_DIR}/BigSur.sparseimage"
fi

VM_NAME="macOS-BigSur"
if [ ! "`vboxmanage list vms | grep '"'"${VM_NAME}"'"'`" ]; then
    vboxmanage createvm -name "${VM_NAME}" -register

    VM_DIR=$(dirname "`vboxmanage showvminfo "${VM_NAME}" --machinereadable | grep -e "^CfgFile=" | sed -e 's/^CfgFile="//' -e 's/"$//'`")    
    vboxmanage createmedium disk -filename "${VM_DIR}/${VM_NAME}.vdi" -size 100000 --format vdi
    vboxmanage storagectl "${VM_NAME}" --name "SATA" --add sata --controller IntelAhci
    vboxmanage storageattach "${VM_NAME}" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "${VM_DIR}/${VM_NAME}.vdi"
    vboxmanage storageattach "${VM_NAME}" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium "${SCRIPT_DIR}/BigSur.iso"

    vboxmanage modifyvm "${VM_NAME}" --ostype MacOS_64
    vboxmanage modifyvm "${VM_NAME}" --acpi on
    vboxmanage modifyvm "${VM_NAME}" --chipset piix3
    vboxmanage modifyvm "${VM_NAME}" --mouse usbtablet
    vboxmanage modifyvm "${VM_NAME}" --keyboard usb
    vboxmanage modifyvm "${VM_NAME}" --firmware efi
    vboxmanage modifyvm "${VM_NAME}" --rtcuseutc on
    vboxmanage modifyvm "${VM_NAME}" --cpus 2
    vboxmanage modifyvm "${VM_NAME}" --memory 4096
    vboxmanage modifyvm "${VM_NAME}" --vram 128
    vboxmanage modifyvm "${VM_NAME}" --audiocontroller hda
    vboxmanage modifyvm "${VM_NAME}" --audioin on
    vboxmanage modifyvm "${VM_NAME}" --audioout on
    vboxmanage modifyvm "${VM_NAME}" --usbxhci on
    vboxmanage modifyvm "${VM_NAME}" --nic1 nat
    vboxmanage modifyvm "${VM_NAME}" --nictype1 virtio
    vboxmanage modifyvm "${VM_NAME}" --clipboard bidirectional
    vboxmanage modifyvm "${VM_NAME}" --draganddrop bidirectional
    vboxmanage setextradata "${VM_NAME}" GUI/ScaleFactor 2.00

    VBoxManage startvm "${VM_NAME}"
fi
