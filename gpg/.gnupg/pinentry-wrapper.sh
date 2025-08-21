#!/bin/bash

# Detect OS and use appropriate pinentry program
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v /opt/homebrew/bin/pinentry-curses >/dev/null 2>&1; then
        exec /opt/homebrew/bin/pinentry-curses "$@"
    elif command -v /usr/local/bin/pinentry-curses >/dev/null 2>&1; then
        exec /usr/local/bin/pinentry-curses "$@"
    elif command -v pinentry-curses >/dev/null 2>&1; then
        exec pinentry-curses "$@"
    else
        echo "Warning: pinentry-curses not found on macOS!" >&2
        echo "You can install it with: brew install pinentry" >&2
        exec /usr/bin/pinentry "$@"
    fi
else
    # Linux and other Unix-like systems
    if command -v /usr/bin/pinentry-curses >/dev/null 2>&1; then
        exec /usr/bin/pinentry-curses "$@"
    elif command -v pinentry-curses >/dev/null 2>&1; then
        exec pinentry-curses "$@"
    else
        echo "Warning: pinentry-curses not found on Linux!" >&2
        echo "You can install it with: sudo pacman -S pinentry (Arch Linux)" >&2
        echo "Or use your distribution's package manager to install pinentry" >&2
        exec /usr/bin/pinentry "$@"
    fi
fi

