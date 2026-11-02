#!/bin/bash
set -euo pipefail

# Select screen region with crosshair
geom=$(slurp 2>/dev/null) || exit 0
tmp=$(mktemp --suffix=.png)
trap 'rm -f "$tmp"' EXIT

# Capture selected region
grim -g "$geom" "$tmp"

# Detect installed tesseract languages (eng, ara if present)
langs=$(tesseract --list-langs 2>/dev/null | grep -E '^(eng|ara)$' | tr '\n' '+' | sed 's/+$//')
if [ -z "$langs" ]; then
    langs="eng"
fi

# Extract text with OCR
text=$(tesseract "$tmp" stdout -l "$langs" --psm 6 2>/dev/null | sed -e 's/[[:space:]]*$//' -e '/^$/d')

if [ -z "$text" ]; then
    notify-send -t 2500 -a "Screen OCR" "🔍 Screen OCR" "No text detected in selected region."
    exit 0
fi

# Copy directly to clipboard
printf '%s' "$text" | wl-copy

# Preview snippet in notification
preview=$(printf '%s' "$text" | head -n 3 | head -c 120)
notify-send -t 3500 -a "Screen OCR" "📋 Text Copied to Clipboard" "$preview"
