#!/bin/bash

set -e
set -o pipefail

echo "Starting E2E tests!"

if [ -f /.dockerenv ]; then
    echo "WARNING: THIS SCRIPT SHOULD BE EXECUTED IN THE DOCKER HOST (OUTSIDE THE SERVICE CONTAINER)";
fi

echo "Getting container output using cURL"
output=$(curl -s "http://localhost/")

echo "Checking for the 'heartbeatBox' UI element"
heartbeatBoxLine=$(echo "$output" | grep "<pre id=\"heartbeatBox\" class=\"heartbeat\">")
if [ "$heartbeatBoxLine" == "" ]; then
    echo "Failed finding the heartbeat box element in the UI!"
    exit 1
else
    echo "Successfully found the heartbeat box element in the UI!"
fi

echo "Checking for the 'status' UI element"
statusLine=$(echo "$output" | grep "<p class=\"status\" id=\"status\">")
if [ "$statusLine" == "" ]; then
    echo "Failed finding the status paragraph element in the UI!"
    exit 1
else
    echo "Successfully found the status paragraph element in the UI!"
fi

echo "Checking the JS script in the UI"
scriptLine=$(echo "$output" | grep "script src=\"/static/main.js")
if [ "$scriptLine" == "" ]; then
    echo "Failed finding the script element in the UI!"
    exit 1
else
    echo "Successfully found the script element in the UI!"
fi

echo "E2E Tests successfully executed!"
