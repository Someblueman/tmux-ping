#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# This runs when the plugin is loaded
main() {
    # Get current status-right and status-left
    local status_right=$(tmux show-option -gqv status-right)
    local status_left=$(tmux show-option -gqv status-left)
    
    # Replace #{ping} with the actual script call
    local ping_script="#($CURRENT_DIR/scripts/ping_monitor.sh)"
    
    # Update status-right if it contains #{ping}
    if [[ "$status_right" == *"#{ping}"* ]]; then
        status_right="${status_right//\#\{ping\}/$ping_script}"
        tmux set-option -gq status-right "$status_right"
    fi
    
    # Update status-left if it contains #{ping}
    if [[ "$status_left" == *"#{ping}"* ]]; then
        status_left="${status_left//\#\{ping\}/$ping_script}"
        tmux set-option -gq status-left "$status_left"
    fi
}

main