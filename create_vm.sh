#!/bin/bash

declare -A vm_ip
declare -i num
declare -i ip
declare -i vm_total

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

ifconfig br-data > /dev/null
if [ "$?" != "0" ]; then
    sudo brctl addbr br-ctrl
    sudo ifconfig br-ctrl up
    sudo brctl addbr br-data
    sudo ifconfig br-data up
fi

vm_total=1
num=0
while [ $num -lt ${vm_total} ]; do
    vm_suffix=$(printf "%02x" $num)
    ip=num+100
    echo "**Create vm secnet-vm${vm_suffix}..."
    . ./kvm-install-vm create -l ${VM_DIR} -L ${VM_DIR} -t secnet -s `pwd`/network-provision.sh -T US/Pacific -M ${vm_suffix} -I 192.168.122.$ip -u secnet -v secnet-vm${vm_suffix}
    vm_ip[$num]=192.168.122.$ip
    num=num+1
done

:>vm_file
echo "vm_name        vm_ip"
echo "-----------------------------"
num=0
while [ $num -lt ${vm_total} ]; do
    vm_suffix=$(printf "%02x" $num)
    echo "secnet-vm${vm_suffix}:   ${vm_ip[$num]}"
    echo "secnet-vm${vm_suffix}:   ${vm_ip[$num]}" >> vm_file
    num=num+1
done
