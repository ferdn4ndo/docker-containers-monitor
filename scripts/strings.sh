#!/bin/bash

set -e
set -o pipefail

# shellcheck disable=SC1091
source ./colors.sh

TERMWIDTH=80

function printMsg() {
    if [ -z "$2" ]; then
        # No specific color informed, perform e regular echo
        echo "$1"

        return
    fi

    # shellcheck disable=SC2059
    printf "%b%s${COLOR_OFF}\n" "${2}" "${1}"
}

function printTitle() {
    titleSize=${#1}

    sizeLeft=$(( ((TERMWIDTH-titleSize)/2) - 1 ))
    sizeRight=$(( ((TERMWIDTH-titleSize+1)/2) - 1 ))

    if [ $sizeLeft -gt 0 ] && [ $sizeRight -gt 0 ]; then
        title="$(printf '=%.0s' $(seq 1 $sizeLeft)) ${1} $(printf '=%.0s' $(seq 1 $sizeRight))"
    else
        title="${1}"
    fi

    printMsg "$title"
}

function printSpacer() {
    printf '=%.0s' $(seq 1 $TERMWIDTH)
}

function printHeader() {
    spacer=$(printSpacer)

    printMsg ""

    printMsg "$spacer" "${COLOR_BACKGROUND_BLUE}${COLOR_BOLD_WHITE}"

    title=$(printTitle "${1}")
    printMsg "$title" "${COLOR_BACKGROUND_BLUE}${COLOR_BOLD_WHITE}"

    printMsg "$spacer" "${COLOR_BACKGROUND_BLUE}${COLOR_BOLD_WHITE}"

    printMsg ""
}

function printSuccess() {
    printMsg "${1}" "${COLOR_BACKGROUND_GREEN}${COLOR_BOLD_WHITE}"
}

function printWarning() {
    printMsg "${1}" "${COLOR_BACKGROUND_YELLOW}${COLOR_BOLD_WHITE}"
}

function printFailure() {
    printMsg "${1}" "${COLOR_BACKGROUND_RED}${COLOR_BOLD_WHITE}"
}
