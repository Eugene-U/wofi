#!/usr/bin/env bash

set -u

# ============ BLACK LIST ============
BLACKLIST=(
    "avahi-discover.desktop"
    "bssh.desktop"
    "bvnc.desktop"
    "qv4l2.desktop"
    "qvidcap.desktop"
    "kitty.desktop"
    "nvidia-settings.desktop"
    "org.pulseaudio.pavucontrol.desktop"
)
# =======================================

# ============ ИКОНКИ ============
ICON_DIR="$HOME/.config/wofi/icons"
ICON_COLOR="#bd93f9"
ICON_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/wofi/icons"
# =================================

APPS_DIRS=(
    "${XDG_DATA_HOME:-$HOME/.local/share}/applications"
    /usr/share/applications
)

is_blacklisted() {
    local id="$1" b
    for b in "${BLACKLIST[@]}"; do
        [[ "$id" == "$b" ]] && return 0
    done
    return 1
}

prepare_icon() {
    local src="$1"
    local dst="$ICON_CACHE/${ICON_COLOR#\#}-${src##*/}"
    if [[ ! -f "$dst" || "$src" -nt "$dst" ]]; then
        mkdir -p "$ICON_CACHE"
        sed -E \
            -e "s/(fill|stroke|stop-color)=\"#[0-9a-fA-F]{3,8}\"/\1=\"$ICON_COLOR\"/g" \
            -e "s/(fill|stroke|stop-color):[[:space:]]*#[0-9a-fA-F]{3,8}/\1:$ICON_COLOR/g" \
            "$src" > "$dst"
    fi
    printf '%s' "$dst"
}

menu=()
declare -A path_of
for dir in "${APPS_DIRS[@]}"; do
    [[ -d "$dir" ]] || continue
    for f in "$dir"/*.desktop; do
        [[ -e "$f" ]] || continue
        id="${f##*/}"
        is_blacklisted "$id" && continue
        grep -qE '^(Hidden|NoDisplay)=true' "$f" && continue
        name="$(grep -m1 '^Name=' "$f" | cut -d= -f2-)"
        [[ -z "$name" ]] && name="$id"
        key="$name"
        [[ -n "${path_of[$key]:-}" ]] && key="$name [${id%.desktop}]"
        path_of[$key]="$f"

        icon="$ICON_DIR/${id%.desktop}.svg"
        [[ -f "$icon" ]] || icon="$ICON_DIR/default.svg"

        menu+=("img:$(prepare_icon "$icon"):text:${key}")
    done
done

[[ ${#menu[@]} -eq 0 ]] && exit 0

choice="$(printf '%s\n' "${menu[@]}" | sort -u | wofi --dmenu --prompt "")"
[[ -z "$choice" ]] && exit 0

exec gio launch "${path_of[$choice]}"
