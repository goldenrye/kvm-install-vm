#!/bin/bash

# SHOULD BE MOVED TO CONFIG FILE !!!
VM_TOTAL=10
VM_PREFIX=asn
VM_DIR=/home/`whoami`/Work/vm
# SHOULD BE MOVED TO CONFIG FILE !!!

declare -i num

#VM_DIR=$1

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

echo "***To destroy [${VM_TOTAL}] VMs under [${VM_DIR}]..."

num=0
while [ $num -lt ${VM_TOTAL} ]; do
    vm_suffix=$(printf "%03d" $num)
    vm_name=${VM_PREFIX}-${vm_suffix}

    echo "**Destroying VM:[${vm_name}]..."
    #   echo "**Delete vm ${vmname}..."
    if [ ! -d ${VM_DIR}/$vm_name ]; then
	echo "  ${VM_DIR}/$vm_name doesn't exist, skipped"
	num=num+1
	continue
    fi

    virsh destroy $vm_name
    virsh undefine $vm_name
    virsh pool-destroy $vm_name
    rm -fr ${VM_DIR}/$vm_name

    num=num+1
done

