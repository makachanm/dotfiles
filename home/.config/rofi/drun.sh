#!/usr/bin/env bash
set -euo pipefail

pins="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/pinned"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/rofi3.druncache"
base=1000000
min_lines=8

pinned=()
if [ -f "$pins" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        line="${line%%#*}"
        line="$(printf '%s' "$line" | tr -d '[:space:]')"
        [ -n "$line" ] && pinned+=("$line")
    done < "$pins"
fi

mkdir -p "$(dirname "$cache")"
for i in "${!pinned[@]}"; do
    echo "$((base - i)) ${pinned[$i]}.desktop"
done > "$cache.tmp"
mv "$cache.tmp" "$cache"

lines=$(( ${#pinned[@]} > min_lines ? ${#pinned[@]} : min_lines ))

exec rofi -show drun -theme-str "listview { lines: $lines; }" "$@"
