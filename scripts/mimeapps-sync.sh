#!/bin/sh
# Back up the live KDE mimeapps into this repo (run before committing).
# Live file is authoritative: HM no longer overwrites it on switch.
set -e
cd "$(dirname "$0")/.."
cp "$HOME/.config/mimeapps.list" home/config/desktop/mimeapps.list
echo "synced ~/.config/mimeapps.list -> home/config/desktop/mimeapps.list"
