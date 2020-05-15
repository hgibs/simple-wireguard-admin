#!/bin/bash

. config.cfg

if [ "$EUID" -ne 0 ] ;
then 
    echo "wg requires root privileges"
    exit 1
fi

if ! [ -z "$1" ] ;
then
  newpubkey="${wgconfig}${1}-publickey"
  if ! [ -f "$newpubkey" ]; then
    echo "$newpubkey does not exist, try a new identifier or manually remove the offending peer in ${wgn}.conf"
    exit 1
  fi
  
  wg set "$wgn" peer "$(cat $newpubkey)" remove
  echo "wg set $wgn peer $(cat $newpubkey) remove"
  if [ $? -eq 0 ] ;
  then
    rm "$newpubkey"
    rm "${1}.conf"
  fi

else
  echo "Please supply a key name!"
  echo "Usage ./remove-user.sh [identifier]"
fi
