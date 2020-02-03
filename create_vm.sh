#!/bin/bash

declare -A vm_ip
declare -i num
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

sudo brctl addbr br-ctrl
sudo brctl addbr br-data

vm_total=2
num=0
while [ $num -lt ${vm_total} ]; do
    vm_suffix=$(printf "%02x" $num)
    echo "**Create vm secnet-vm${vm_suffix}..."
    . ./kvm-install-vm create -l ${VM_DIR} -L ${VM_DIR} -t ubuntu1604 -T US/Pacific -M ${vm_suffix} -u secnet -v secnet-vm${vm_suffix}
    vm_ip[$num]=$IP
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


#num=0
#while [ $num -lt ${vm_total} ]; do
#    ssh-keygen -R ${vm_ip[$num]}
#    ssh -oStrictHostKeyChecking=no secnet@${vm_ip[$num]} sudo apt update
#    ssh -oStrictHostKeyChecking=no secnet@${vm_ip[$num]} sudo apt install docker.io -y
#    ssh -oStrictHostKeyChecking=no secnet@${vm_ip[$num]} sudo usermod -aG docker secnet
#    ssh -oStrictHostKeyChecking=no secnet@${vm_ip[$num]} docker pull polycubenetwork/polycube:latest
#    num=num+1
#done

