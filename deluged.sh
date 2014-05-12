#!/bin/sh

mkdir -p /config

if ! grep -q deluge /config/auth 2> /dev/null; then
    PW=$(tr -cd [:alnum:] < /dev/urandom | fold -w 32 | head -1)
    echo "Username: deluge"
    echo "Password: ${PW}"
    echo "deluge:${PW}:10" >> /config/auth
fi

IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

/usr/bin/deluged -u ${IP} -i ${IP} $@
