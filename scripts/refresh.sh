#!/bin/bash

# shellcheck disable=SC1091
source ./functions.sh

generatedAt=$(date +'%Y-%m-%dT%H:%M:%S')

STATS_FILE=${STATS_FILE:-/usr/share/nginx/html/stats.txt}

heartbeat=$(generateHeartbeat)

printMsg "${heartbeat}" > "${STATS_FILE}"

printMsg "Exported heartbeat with ${#heartbeat} bytes at ${generatedAt}!" > /tmp/mypipe
