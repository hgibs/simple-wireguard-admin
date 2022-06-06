#!/usr/bin/env bash

. config.cfg

serv_pubkey=$(wg show $wgn | head -n 4 | grep "public key" | cut -d' ' -f5)

if [ "$EUID" -ne 0 ] ;
then
    echo "wg requires root privileges"
    exit 1
fi

if ! [ -z "$1" ] ;
then
  newprivkey="${wgconfig}${1}-privatekey"
  if [ -f "$newprivkey" ]; then
    echo "$newprivkey exists, try a new identifier"
    exit 1
  fi

  newpubkey="${wgconfig}${1}-publickey"
  if [ -f "$newpubkey" ]; then
    echo "$newpubkey exists, try a new identifier"
    exit 1
  fi

  newconf="${1}.conf"
  if [ -f "$newconf" ]; then
    echo "$newconf exists, try a new identifier"
    exit 1
  fi

  cat config.cfg > config.cfg.bak

  if [ "$latestclient4" -ge 254 ] ;
  then
    #increment the v4thirdoctet
    latestclient4=0
    v4thirdoctet="$(($v4thirdoctet + 1))"
    #save these to the config file
    sed -i "s/v4thirdoctet=.*/v4thirdoctet=${v4thirdoctet} #automatically incremented/" config.cfg
  fi

  latestclient4="$(($latestclient4 + 1))"

  echo "Client assigned v4 address: ${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}"

  wg genkey | tee "$newprivkey" | wg pubkey > "$newpubkey"
  echo "wg genkey | tee $newprivkey | wg pubkey > $newpubkey"

  wg set "$wgn" peer "$(cat $newpubkey)" allowed-ips "${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}/32"
  echo "wg set $wgn peer $(cat $newpubkey) allowed-ips ${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}/32"

  sed -i "s/latestclient4=.*/latestclient4=${latestclient4} #automatically incremented/" config.cfg

  #Address = 10.0.99.${v4}/32, fd99:feed::${v6}/128, 192.168.0.0/16, 2001:470:b962:ace::/64
  printf "#${newconf} created on $(date) \n
[Interface]
PrivateKey = $(cat $newprivkey)
Address = ${v4firstoctet}.${v4secondoctet}.${v4thirdoctet}.${latestclient4}/${v4cidr}
DNS = 1.1.1.1, 1.0.0.1 \n
[Peer]
PublicKey = $serv_pubkey
Endpoint = $endpoint
AllowedIPs = 0.0.0.0/0
\n
" > $newconf
  qrencode -t ansiutf8 < "${newconf}"
  echo "Created: $newconf for transfer to client"

  rm -f $newprivkey
  chmod 660 $newconf #this contains private key, better keep it private
  printf "Take care of this configuration file - it contains the private key of the client. Transfer it securely, then erase it here. \n\
You can remove this user by running the command ./remove-user.sh $1 \n"
else
  echo "Please supply a key name!"
  echo "Usage ./create-key.sh [identifier]"
fi
