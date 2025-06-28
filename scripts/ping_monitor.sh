#!/usr/bin/env bash

# File to store ping results
PING_FILE="/tmp/tmux_ping_data.txt"
PING_PID_FILE="/tmp/tmux_ping.pid"

# Default target (Google DNS)
TARGET="${TMUX_PING_TARGET:-8.8.8.8}"

# Function to start background ping
start_ping() {
    # Kill any existing ping process
    if [ -f "$PING_PID_FILE" ]; then
        kill $(cat "$PING_PID_FILE") 2>/dev/null
        rm -f "$PING_PID_FILE"
    fi
    
    # Start new ping process
    (
        ping -i 1 "$TARGET" | while IFS= read -r line; do
            if [[ "$line" =~ time=([0-9]+\.?[0-9]*) ]]; then
                echo "${BASH_REMATCH[1]}" >> "$PING_FILE"
                # Keep only last 10 entries
                tail -n 10 "$PING_FILE" > "$PING_FILE.tmp" && mv "$PING_FILE.tmp" "$PING_FILE"
            fi
        done
    ) &
    echo $! > "$PING_PID_FILE"
}

# Check if ping process is running
if [ -f "$PING_PID_FILE" ]; then
    PID=$(cat "$PING_PID_FILE")
    if ! kill -0 "$PID" 2>/dev/null; then
        start_ping
    fi
else
    start_ping
fi

# Calculate and display average
if [ -f "$PING_FILE" ] && [ -s "$PING_FILE" ]; then
    avg=$(awk '{ sum += $1; n++ } END { if (n > 0) printf "%.1f", sum/n }' "$PING_FILE")
    if [ -n "$avg" ]; then
        echo "${avg}ms"
    else
        echo "..."
    fi
else
    echo "..."
fi