#!/bin/bash

# Interactive screenshot annotation script for Niri / Wayland
# Drag an area with your mouse to annotate in Satty.

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"

if command -v satty >/dev/null 2>&1 && command -v grim >/dev/null 2>&1 && command -v slurp >/dev/null 2>&1; then
    # Select area with crosshair
    GEOM=$(slurp -d -c "#89b4fa" -b "#1e1e2e80" -s "#cba6f733")
    [ -z "$GEOM" ] && exit 0 # user cancelled (Esc or right click)

    # Pipe region screenshot directly into Satty
    FILENAME="$SCREENSHOTS_DIR/screenshot-$(date +%Y%m%d_%H%M%S).png"
    grim -g "$GEOM" - | satty --filename - --output-filename "$FILENAME"
elif command -v spectacle >/dev/null 2>&1; then
    spectacle -r
else
    niri msg action screenshot
fi
