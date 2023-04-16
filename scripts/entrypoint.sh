#!/bin/bash

set -e
set -o pipefail

# shellcheck disable=SC1091
source ./functions.sh

printHeader "Docker Conatiners Monitor"

printMsg "Starting the Nginx server"
nginx

REFRESH_EVERY_SECONDS=${REFRESH_EVERY_SECONDS:-5}

printMsg "Starting the stats watcher refreshing every $REFRESH_EVERY_SECONDS second(s)"

mkfifo /tmp/mypipe

nohup watch -n"$REFRESH_EVERY_SECONDS" "sh /scripts/refresh.sh" > /dev/null & tail -f /tmp/mypipe

printMsg "Reading the custom pipe output"
tail -f /tmp/mypipe
