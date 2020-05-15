#!/bin/bash

if ! [ -z "$1" ] ;
then
wg set wg0 peer "$(cat $1-publickey)" remove
  if [ $? -eq 0 ] ;
  then
    rm "${1}-privatekey"
    rm "${1}-publickey"
    rm "${1}.conf"
  fi

else
  echo "no keyname provided!"
fi
