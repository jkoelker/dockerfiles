#!/bin/sh

mkdir -p /sync
if [ ! -f /sync/sync.conf ]; then
    cp /default_sync.conf /sync/sync.conf
fi

/btsync $@
