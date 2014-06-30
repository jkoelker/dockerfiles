#!/bin/sh

mkdir -p /config
mkdir -p /data

/usr/bin/python /sickrage/SickBeard.py $@
