#!/bin/bash

declare -i num

num=0
while [ $num -lt 2 ]; do
    vm_suffix=$(printf "%02x" $num)
    vmname=secnet-vm${vm_suffix}
    echo "**Delete vm ${vmname}..."	
    virsh destroy $vmname
    virsh undefine $vmname
    virsh pool-destroy $vmname
    rm -fr /volume/tmp/$vmname

    num=num+1   
done 

