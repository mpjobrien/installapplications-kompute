#!/bin/sh

# Kick off a sync to WS1 via hubcli

if [ -e = "/usr/local/bin/hubcli" ]; then
    hubcli sync
else
    echo "hubcli not installed. Exiting"
    exit 1
fi

exit 0