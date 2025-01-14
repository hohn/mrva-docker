#!/bin/bash
set -e

# Function to handle termination signals (e.g., SIGTERM)
cleanup() {
    echo "Stopping server..."
    kill $PID
    wait $PID 2>/dev/null
    exit 0
}

# Trap termination signals to clean up properly
trap cleanup SIGTERM SIGINT

# Loop to restart the server if it stops
while true; do
    echo "Starting server..."
    /usr/local/bin/mrvaserver "$@" &
    PID=$!
    wait $PID
    echo "Server stopped. Restarting..."
    sleep 1
done
