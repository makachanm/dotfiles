#!/bin/sh
set -e
pkexec "$(nix --extra-experimental-features "nix-command flakes" build --no-link --print-out-paths "$(dirname "$(realpath "$0")")")"
