#!/usr/bin/env bash

for dir in "${XDG_DATA_HOME:-$HOME/.local/share}/applications" /usr/share/applications; do
  [[ -d "$dir" ]] || continue
  for f in "$dir"/*.desktop; do
    [[ -e "$f" ]] || continue
    id="${f##*/}"
    grep -qE '^(Hidden|NoDisplay)=true' "$f" && continue
    name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
    svg="${id%.desktop}.svg"
    [[ -f "$HOME/.config/wofi/icons/$svg" ]] && st="есть своя" || st="-> default.svg"
    printf '%-36s %-30s %s\n' "$svg" "$name" "$st"
  done
done | sort
