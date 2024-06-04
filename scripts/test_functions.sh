#!/bin/bash

set -e
set -o pipefail

# shellcheck disable=SC1091
source ./asserts.sh

###
### The UTs of the custom service methods (in functions.sh) will go here
###

testGenerateHeartbeat() {
    printMsg "Testing the generateHeartbeat method"

    exec 5>&1
    output=$(generateHeartbeat echo "Default command successfully executed")

    assertStringContains "${output}" "Docker version"

    assertStringContains "${output}" "Uptime"
    assertStringContains "${output}" "load average:"

    assertStringContains "${output}" "Containers stats"
    assertStringContains "${output}" "CONTAINER ID"
    assertStringContains "${output}" "NAME"
    assertStringContains "${output}" "CPU %"
    assertStringContains "${output}" "MEM USAGE / LIMIT"
    assertStringContains "${output}" "MEM %"
    assertStringContains "${output}" "NET I/O"
    assertStringContains "${output}" "BLOCK I/O"
    assertStringContains "${output}" "PIDS"

    assertStringContains "${output}" "Disk Usage"
    assertStringContains "${output}" "Filesystem"
    assertStringContains "${output}" "Size"
    assertStringContains "${output}" "Used"
    assertStringContains "${output}" "Avail"
    assertStringContains "${output}" "Use%"
    assertStringContains "${output}" "Mounted on"

    assertStringContains "${output}" "Memory Usage"
    assertStringContains "${output}" "MemTotal"
    assertStringContains "${output}" "MemFree"
    assertStringContains "${output}" "MemAvailable"
    assertStringContains "${output}" "Cached"
    assertStringContains "${output}" "SwapCached"
    assertStringContains "${output}" "Active"
    assertStringContains "${output}" "Inactive"
    assertStringContains "${output}" "Active"
    assertStringContains "${output}" "Inactive"
    assertStringContains "${output}" "Active"
    assertStringContains "${output}" "Inactive"
    assertStringContains "${output}" "SwapTotal"
    assertStringContains "${output}" "SwapFree"

    assertStringContains "${output}" "Command Output"
    assertStringContains "${output}" "Default command successfully executed"
}

if [ -z "$1" ]; then
    printWarning "No argument supplied, running all the tests in the file!"

    testGenerateHeartbeat
else
    # shellcheck disable=SC2199
    [[ "$@" =~ 'testGenerateHeartbeat' ]] && ( testGenerateHeartbeat )
fi

printSuccess "ALL TESTS PASSED!"
