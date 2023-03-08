#!/bin/sh

# Kick off a sync to WS1 via hubcli

if [ -e = "/usr/local/bin/hubcli" ]; then
    /usr/local/bin/hubcli sync
else
    echo "hubcli not installed. Exiting"
fi

exit 0