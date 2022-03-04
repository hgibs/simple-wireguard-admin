#!/usr/bin/env bash

. config.cfg

echo "$wgconfig"
echo "${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}/${v4cidr}"

if [ "$latestclient4" -ge 254 ] ;
then
  #increment the v4thirdoctet
  latestclient4=0
  v4thirdoctet="$(($v4thirdoctet + 1))"
  #save these to the config file
  sed -i.bak "s/v4thirdoctet=.*/v4thirdoctet=${v4thirdoctet} #automatically incremented/" config.cfg
fi

latestclient4="$(($latestclient4 + 1))"

echo "Client assigned v4 address: ${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}"

sed -i.bak "s/latestclient4=.*/latestclient4=${latestclient4} #automatically incremented/" config.cfg
