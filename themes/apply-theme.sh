#!/usr/bin/env bash
THEME_DIR="$HOME/.config/themes"
THEME="$1"

if [[ -z "$THEME" ]]; then
    echo "Usage: apply-theme.sh <theme-name>"
    exit 1
fi

THEME_PATH="$THEME_DIR/$THEME"
if [[ ! -d "$THEME_PATH" ]]; then
    echo "Theme not found: $THEME"
    exit 1
fi

source "$THEME_PATH/colors.conf"

# Update current symlink
ln -sfn "$THEME_PATH" "$THEME_DIR/current"

# Apply Hyprland border colors live (no restart needed)
hyprctl keyword general:col.active_border "$ACTIVE_BORDER"
hyprctl keyword general:col.inactive_border "$INACTIVE_BORDER"

# Write Waybar color CSS
cat > "$HOME/.config/waybar/colors.css" << EOF
@define-color wb_bg ${WB_BG};
@define-color wb_fg ${WB_FG};
@define-color wb_accent ${WB_ACCENT};
@define-color wb_hover ${WB_HOVER};
@define-color wb_active_fg ${WB_ACTIVE_FG};
@define-color wb_tooltip_border ${WB_TOOLTIP_BORDER};
@define-color wb_warn ${WB_WARN};
@define-color wb_crit ${WB_CRIT};
EOF

# Write Rofi colors
cat > "$HOME/.config/rofi/colors.rasi" << EOF
* {
    bg:          ${ROFI_BG};
    bg-alt:      ${ROFI_BG};
    border-col:  ${ROFI_BORDER};
    fg:          ${ROFI_FG};
    fg-dim:      ${ROFI_FG_DIM};
    selected-fg: ${ROFI_SELECTED_FG};
}
EOF

# Reload Waybar CSS live (no restart)
pkill -SIGUSR2 waybar
