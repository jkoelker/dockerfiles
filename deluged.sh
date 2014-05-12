#!/bin/sh

mkdir -p /config

if ! grep -q deluge /config/auth 2> /dev/null; then
    PW=$(tr -cd [:alnum:] < /dev/urandom | fold -w 32 | head -1)
    echo "Username: deluge"
    echo "Password: ${PW}"
    echo "deluge:${PW}:10" >> /config/auth
fi

/usr/bin/deluged $@
