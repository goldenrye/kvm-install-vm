#!/bin/bash

declare -i num

VM_DIR=$1

function help {
    echo "$0 <VM_DIR>"
}

if [ "x"${VM_DIR} = "x" ]; then
   help
   exit
fi
if [ ! -d ${VM_DIR} ]; then
    mkdir ${VM_DIR}
fi

num=0
while [ $num -lt 2 ]; do
    vm_suffix=$(printf "%02x" $num)
    vmname=secnet-vm${vm_suffix}
    echo "**Delete vm ${vmname}..."
    virsh destroy $vmname
    virsh undefine $vmname
    virsh pool-destroy $vmname
    rm -fr ${VM_DIR}/$vmname

    num=num+1
done

