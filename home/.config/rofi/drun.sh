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
touch "$cache"

{
    for i in "${!pinned[@]}"; do
        echo "$((base - i)) ${pinned[$i]}.desktop"
    done
    awk -v base="$base" -v list="${pinned[*]}" '
        BEGIN { n = split(list, a, " "); for (i = 1; i <= n; i++) skip[a[i] ".desktop"] = 1 }
        NF >= 2 && !($2 in skip) { print ($1 > base - 1000 ? 0 : $1), $2 }
    ' "$cache"
} > "$cache.tmp"
mv "$cache.tmp" "$cache"

exec rofi -show drun "$@"
