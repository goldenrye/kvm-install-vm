#!/bin/bash

# SHOULD BE MOVED TO CONFIG FILE !!!
VM_TOTAL=2
VM_PREFIX=asn
VM_IP_PREFIX=100.1.1
VM_USER=secnet
VM_DISTRO=asn
#VM_DIR=/tmp/vm/vm
VM_DIR=/home/`whoami`/Work/vm
# SHOULD BE MOVED TO CONFIG FILE !!!

declare -i num
declare -i ip
declare -A vm_ips
declare -A vm_namess

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
if [ ! -f ${VM_DIR}/asn-vm.img ]; then
    echo "Please copy the VM image to ${VM_DIR} first"
    exit
fi

ifconfig br-data > /dev/null
if [ "$?" != "0" ]; then
    stotaudo brctl addbr br-ctrl
    sudo ifconfig br-ctrl up
    sudo brctl addbr br-data
    sudo ifconfig br-data up
fi

echo "***To create [${VM_TOTAL}] VMs under [${VM_DIR}]..."
num=0
while [ $num -lt ${VM_TOTAL} ]; do
    vm_mac=$(printf "%02x" $num)

    ip=num+100
    vm_ip=${VM_IP_PREFIX}.${ip}

    vm_suffix=$(printf "%03d" $num)
    vm_name=${VM_PREFIX}-${vm_suffix}

    echo "**Creating VM:[${vm_name}]  DISTRO:[${VM_DISTRO}]  IP:[${vm_ip}]  MAC_SUFFIX:[${vm_mac}]..."

    ./kvm-install-vm create -l ${VM_DIR} -L ${VM_DIR} -t ${VM_DISTRO} \
		     -s `pwd`/network-provision.sh -T US/Pacific -M ${vm_mac} \
		     -I ${vm_ip} -u ${VM_USER} -v ${vm_name}

    vm_names[$num]=${vm_name}
    vm_ips[$num]=${vm_ip}
    num=num+1
done

echo ""
echo -e "VM_NAME\t\t IP"
echo "-----------------------------"
num=0
while [ $num -lt ${VM_TOTAL} ]; do
    vm_suffix=$(printf "%03d" $num)
    echo -e "${vm_names[$num]}:\t\t ${vm_ips[$num]}"
#    echo "${vm_names[$num]}:\\t  ${vm_ips[$num]}" >> vm_file
    num=num+1
done
