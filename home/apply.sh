#!/bin/sh
set -e
nix --extra-experimental-features "nix-command flakes" run home-manager -- switch --flake "$(dirname "$(realpath "$0")")#maka" -b hm-backup
