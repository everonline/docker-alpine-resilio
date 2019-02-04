#!/bin/sh

mkdir -p /mnt/sync/folders
mkdir -p /mnt/sync/config

if ! [ -f /mnt/sync/sync.conf ]; then
    cp /etc/sync.conf /mnt/sync/sync.conf;
fi

exec /usr/local/bin/rslsync --config /mnt/sync/sync.conf --nodaemon $*