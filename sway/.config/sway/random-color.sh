#!/usr/bin/env bash

# generate_random_color() {
#     # Generate a random number between 0 and 16777215 (which is FFFFFF in hexadecimal)
#     local random_color=$((RANDOM % 16777216))
#     # Convert the random number to a hexadecimal string and remove the leading '0x'
#     printf "%06x\n" "$random_color"
# }

generate_random_color() {
    # Generate random values for R, G, and B components
    local r=$((RANDOM % 256))
    local g=$((RANDOM % 256))
    local b=$((RANDOM % 256))
    # Convert each component to a two-digit hexadecimal string
    printf "%02x%02x%02x\n" "$r" "$g" "$b"
}


generate_random_color
