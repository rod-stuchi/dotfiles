#!/usr/bin/env bash

set -euo pipefail

plugins=(
  "beyondlex/herdr-recent-navigator"
)

for plugin in "${plugins[@]}"; do
  echo "Installing $plugin..."
  herdr plugin install "$plugin" --yes
done
