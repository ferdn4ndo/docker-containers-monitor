#!/bin/bash

set -e
set -o pipefail

# shellcheck disable=SC1091
source ./strings.sh

###
### Custom service methods will go here
###

function generateHeartbeat() {
    generatedAt=$(date +'%Y-%m-%dT%H:%M:%S')
    dockerVersion=$(docker -v)
    dockerStats=$(docker stats --no-stream --all)
    diskUsage=$(df -h /)
    # shellcheck disable=SC2002
    memoryStats=$(cat /proc/meminfo | grep -E "Mem|Cached|Swap|ctive")
    totalUptime="$(uptime) [1m, 5m, 15m]"
    spacer="$(printSpacer)"

    STATS_FILE=${STATS_FILE:-/usr/share/nginx/html/stats.txt}

    printMsg "HEARTBEAT LOG AT ${generatedAt}"

    printMsg ""
    printMsg "${spacer}"
    printMsg "Docker version"
    printMsg "${spacer}"
    printMsg "${dockerVersion}"

    printMsg ""
    printMsg "${spacer}"
    printMsg "Uptime"
    printMsg "${spacer}"
    printMsg "${totalUptime}"

    printMsg "${spacer}"
    printMsg "Containers stats"
    printMsg "${spacer}"
    printMsg "${dockerStats}"

    printMsg ""
    printMsg "${spacer}"
    printMsg "Disk Usage"
    printMsg "${spacer}"
    printMsg "${diskUsage}"

    printMsg ""
    printMsg "${spacer}"
    printMsg "Memory Usage"
    printMsg "${spacer}"
    printMsg "${memoryStats}"

    commandOutput="(EMPTY)"
    if [ $# -gt 0 ]
    then
        commandOutput=$(exec "$@")
        printMsg ""
        printMsg "${spacer}"
        printMsg "Command Output"
        printMsg "${spacer}"
        printMsg "${commandOutput}"
    fi

    printMsg ""
    printMsg "END OF LOG"
}
