#!/bin/sh
set -e
nix run home-manager -- switch --flake "$(dirname "$(realpath "$0")")#maka" -b hm-backup
