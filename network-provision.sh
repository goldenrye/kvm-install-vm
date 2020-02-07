IFS="." read ip1 ip2 ip3 ip4 <<< ${IP} 
GW=${ip1}.${ip2}.${ip3}."1"

cat <<EOF > /tmp/network.yaml
network:
  ethernets:
    ens3:
      addresses:
        - ${IP}/24
      gateway4: ${GW} 
      nameservers:
        addresses: [8.8.8.8]     
      match:
        macaddress: "50:00:00:00:00:${MAC}"
      set-name: ens3
    ens4:
      addresses:
        - 172.16.1.${ip4}/24
      match:
        macaddress: "52:00:00:00:00:${MAC}"
      set-name: ens4 
    ens5:
      addresses:
        - 172.16.2.${ip4}/24
      match:
        macaddress: "54:00:00:00:00:${MAC}"
      set-name: ens5 
EOF

cp -f /tmp/network.yaml /etc/netplan/50-cloud-init.yaml
netplan apply
