#!/bin/bash

declare -A vm_ip
declare -i num
declare -i vm_total

vm_total=2
num=0
while [ $num -lt ${vm_total} ]; do
    vm_suffix=$(printf "%02x" $num)
    echo "**Create vm secnet-vm${vm_suffix}..."	
    . ./kvm-install-vm create -l /volume/tmp -L /volume/tmp -t ubuntu1604 -T US/Pacific -M ${vm_suffix} -u secnet secnet-vm${vm_suffix}
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
