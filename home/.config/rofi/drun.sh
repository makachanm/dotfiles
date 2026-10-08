#!/usr/bin/env bash
set -euo pipefail

pinned=(
    zen-browser
    thorium-browser
    Alacritty
    thunar
    code
    slack
    vesktop
    com.ayugram.desktop
    io.github.nolight132.sonora
)

cache="${XDG_CACHE_HOME:-$HOME/.cache}/rofi3.druncache"
base=1000000

mkdir -p "$(dirname "$cache")"
for i in "${!pinned[@]}"; do
    echo "$((base - i)) ${pinned[$i]}.desktop"
done > "$cache.tmp"
mv "$cache.tmp" "$cache"

exec rofi -show drun "$@"
