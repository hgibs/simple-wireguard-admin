#!/bin/bash

if ! [ -z "$1" ] ;
then
qrencode -t ansiutf8 < "${1}.conf"
else
echo "Which conf file to QREncode?"
fi
