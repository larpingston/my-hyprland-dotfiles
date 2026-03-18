#!/usr/bin/env bash
THEME_DIR="$HOME/.config/themes"
APPLY="$THEME_DIR/apply-theme.sh"

CURRENT=$(basename "$(readlink "$THEME_DIR/current" 2>/dev/null)" 2>/dev/null)

CHOSEN=$(ls -d "$THEME_DIR"/*/  \
    | xargs -I{} basename {} \
    | grep -Ev '^current$' \
    | sed "s/^${CURRENT}$/> &/" \
    | rofi -dmenu \
        -p "Theme" \
        -i \
        -no-custom \
        -theme-str 'window {width: 240px;}' \
        -mesg "active: ${CURRENT:-none}")

CHOSEN="${CHOSEN#> }"

[[ -n "$CHOSEN" ]] && "$APPLY" "$CHOSEN"
