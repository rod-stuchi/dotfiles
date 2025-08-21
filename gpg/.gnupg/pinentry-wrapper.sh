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
        exec /usr/bin/pinentry "$@"
    fi
else
    # Linux and other Unix-like systems
    if command -v /usr/bin/pinentry-curses >/dev/null 2>&1; then
        exec /usr/bin/pinentry-curses "$@"
    elif command -v pinentry-curses >/dev/null 2>&1; then
        exec pinentry-curses "$@"
    else
        exec /usr/bin/pinentry "$@"
    fi
fi

