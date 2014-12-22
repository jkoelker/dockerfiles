#!/bin/sh

mkdir -p /sync
if [ ! -f /sync/sync.conf ]; then
    cp /default_sync.conf /sync/sync.conf
fi

if [ "$BTSYNC_AUTOUPDATE" == true ]; then
    wget -O - ${BTSYNC_URL} | tar xzf - --overwrite -C / btsync
fi

exec /btsync $@
