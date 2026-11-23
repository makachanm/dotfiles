#!/bin/sh
set -e
pkexec "$(nix build --no-link --print-out-paths "$(dirname "$(realpath "$0")")")"
