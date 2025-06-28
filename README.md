# tmux-ping

A tmux plugin that displays average network latency in your status bar.

## What it does

Shows a rolling average of ping times to monitor network latency: `5.8ms`

## Installation

### With Tmux Plugin Manager (TPM)

Add to your `.tmux.conf`:
```bash
set -g @plugin 'Someblueman/tmux-ping'
```

Then press `prefix + I` to install.

### Manual Installation

Clone the repo:
```bash
git clone https://github.com/Someblueman/tmux-ping ~/.tmux/plugins/tmux-ping
```

Add to your `.tmux.conf`:
```bash
run-shell ~/.tmux/plugins/tmux-ping/ping.tmux
```

## Usage

Add `#{ping}` to your status-right or status-left:
```bash
set -g status-right '#{ping} | %H:%M'
```

## Configuration

You can specify a custom ping target by setting an environment variable:
```bash
export TMUX_PING_TARGET="1.1.1.1"  # Default is 8.8.8.8
```

Add this to your shell configuration file (`.bashrc`, `.zshrc`, etc.) to make it permanent.

## How it works

- Runs continuous ping in the background
- Calculates rolling average of the last 10 ping results
- Updates every second with minimal resource usage
- Displays latency in milliseconds (e.g., "5.8ms")

## Requirements

- macOS or Linux with standard `ping` command
- tmux 1.9 or higher
