#!/bin/bash

set -e
set -o pipefail

# shellcheck disable=SC1091
source ./functions.sh

printHeader "Docker Containers Monitor"

printMsg "Starting the Nginx server"
nginx

REFRESH_EVERY_SECONDS=${REFRESH_EVERY_SECONDS:-5}

printMsg "Starting the stats watcher refreshing every $REFRESH_EVERY_SECONDS second(s)"

FIFO_PATH="${FIFO_PATH:-/tmp/docker_containers_monitor}"

if [[ -p $FIFO_PATH ]]; then
    printMsg "Expected FIFO pipe found at $FIFO_PATH"
else
    printMsg "Creating FIFO pipe at $FIFO_PATH"
    mkfifo "$FIFO_PATH"
fi

printMsg "Entering nohup watch loop every $REFRESH_EVERY_SECONDS seconds"
nohup watch -n"$REFRESH_EVERY_SECONDS" "sh /scripts/refresh.sh $*" > /dev/null & tail -f "$FIFO_PATH"

printMsg "Reading the custom pipe output"
tail -f "$FIFO_PATH"
