#!/bin/bash

v4shiftoctet=0

if ! [ -z "$1" ] ;
then
  v4="$(cat ipv4.next)"
  v6="$(cat ipv6.next)"

 # wg-quick down wg0
  wg genkey | tee "${1}-privatekey" | wg pubkey > "$1-publickey"
  echo "wg genkey | tee ${1}-privatekey | wg pubkey > $1-publickey"
  #wg-quick up wg0
  wg set wg0 peer "$(cat ${1}-publickey)" allowed-ips "10.99.$v4shiftoctet.$v4/32,fd99:feed::$v6/128"
  echo "wg set wg0 peer $(cat ${1}-publickey) allowed-ips 10.99.$v4shiftoctet.$v4/32,fd99:feed::$v6/128"

  v4next="$(($v4 + 1))"
  v6next="$(($v6 + 1))"
  echo "Next v4 address: 10.99.$v4shiftoctet.$v4next"
  echo "Next v6 address: fd99:feed::$v6next"

  echo "$v4next" > ipv4.next
  echo "$v6next" > ipv6.next

  #generate conf file
  newconf="${1}.conf"
  echo $newconf
  #Address = 10.0.99.${v4}/32, fd99:feed::${v6}/128, 192.168.0.0/16, 2001:470:b962:ace::/64
  printf "#${newconf} created on $(date) \n
[Interface]
PrivateKey = $(cat ${1}-privatekey)
Address = 10.99.$v4shiftoctet.${v4}/16, fd99:feed::${v6}/64 \n
[Peer]
PublicKey = $(cat ${1}-publickey)
Endpoint = vpn.hollandgibson.com:51820
AllowedIPs = 0.0.0.0/0, ::/0
\n
" > $newconf
  qrencode -t ansiutf8 < "/etc/wireguard/$newconf"
else
  echo "Please supply a key name!"
fi

