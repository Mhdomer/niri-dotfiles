#!/bin/bash

# Interactive screenshot annotation script for Niri / Wayland
# Captures selected region, opens Satty for arrows, blur/redaction, text, and saves/copies.

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"

if command -v satty >/dev/null 2>&1 && command -v grim >/dev/null 2>&1 && command -v slurp >/dev/null 2>&1; then
    # Modern Wayland annotation pipeline:
    GEOM=$(slurp -d -c "#89b4fa" -b "#1e1e2e80" -s "#cba6f733")
    [ -z "$GEOM" ] && exit 0 # cancelled by user

    FILENAME="$SCREENSHOTS_DIR/screenshot-$(date +%Y%m%d_%H%M%S).png"
    grim -g "$GEOM" - | satty --filename - --fullscreen --output-filename "$FILENAME" --early-exit --copy-command "wl-copy"
elif command -v spectacle >/dev/null 2>&1; then
    spectacle -r
else
    niri msg action screenshot
fi
