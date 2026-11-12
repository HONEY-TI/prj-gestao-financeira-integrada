#!/usr/bin/env bash
set -e

if ! command -v agy >/dev/null 2>&1; then
    wget -qO /tmp/agy-install.sh https://antigravity.google/cli/install.sh
    bash /tmp/agy-install.sh
    rm -f /tmp/agy-install.sh
fi