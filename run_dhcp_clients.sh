#!/bin/sh

if [ $# -ne 2 ]
then
  echo "*****************************************************************"
  echo "Example usage: ./run_dhcp_clients.sh <interface> <clients count>"
  echo "e.g.    ./run_dhcp_clients.sh eth0 100\n"
  echo "*****************************************************************"
else
  for i in $(eval echo {1..$2})
    do
      echo $i
      ip netns add client$i
      ip link add name cif$i link $1 type macvlan
      ip link set cif$i netns client$i
      ip netns exec client$i ip link set cif$i up
      ip netns exec client$i dhclient cif$i &
    done;
fi
