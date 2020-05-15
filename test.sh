#!/usr/bin/env bash

. config.cfg

echo "$wgconfig"
echo "${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}/${v4cidr}"
echo "${ipv6_prefix}:${latestclient6}/${v6cidr}"

if [ "$latestclient4" -ge 254 ] ;
then
  #increment the v4thirdoctet
  latestclient4=0
  v4thirdoctet="$(($v4thirdoctet + 1))"
  #save these to the config file
  sed -i.bak "s/v4thirdoctet=.*/v4thirdoctet=${v4thirdoctet} #automatically incremented/" config.cfg
fi

if [ "$latestclient6" -ge 9999 ] ;
then
  #haven't done the math to do more yet
  echo "This script has hit its limit of available IPs to assign"
  echo "Please consider using a more fully featured wireguard manager"
  exit 1
fi

latestclient4="$(($latestclient4 + 1))"
latestclient6="$(($latestclient6 + 1))"

echo "Client assigned v4 address: ${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}"
echo "Client assigned v6 address: ${ipv6_prefix}:${latestclient6}"

sed -i.bak "s/latestclient4=.*/latestclient4=${latestclient4} #automatically incremented/" config.cfg
sed -i.bak "s/latestclient6=.*/latestclient6=${latestclient6} #automatically incremented/" config.cfg