#!/bin/bash
set -e

# Function to handle termination signals (e.g., SIGTERM)
cleanup() {
    echo "Stopping agent..."
    kill $PID
    wait $PID 2>/dev/null
    exit 0
}

# Trap termination signals to clean up properly
trap cleanup SIGTERM SIGINT

# Loop to restart the agent if it stops
while true; do
    echo "Starting agent..."
    /usr/local/bin/mrvaagent &
    PID=$!
    wait $PID
    echo "Agent stopped. Restarting..."
    sleep 1
done
