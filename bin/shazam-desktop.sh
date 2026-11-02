#!/bin/bash
set -euo pipefail

if ! command -v songrec >/dev/null 2>&1; then
    notify-send -u critical -a "Shazam" "🎵 SongRec Required" "Please install it in terminal: sudo pacman -S songrec"
    exit 1
fi

notify-send -t 3000 -a "Shazam" "🎧 Listening..." "Sampling audio from your speakers..."

TMP_DIR="${XDG_RUNTIME_DIR:-/tmp}/shazam-desktop"
mkdir -p "$TMP_DIR"
TMP_WAV="$TMP_DIR/sample.wav"
trap 'rm -f "$TMP_WAV"' EXIT

# Record 4 seconds from default PipeWire monitor sink (speaker output)
MONITOR_SINK="$(pactl get-default-sink).monitor"
pw-record --target="$MONITOR_SINK" --format=s16 --rate=44100 --channels=2 "$TMP_WAV" >/dev/null 2>&1 &
REC_PID=$!

sleep 4
kill -INT "$REC_PID" 2>/dev/null || true
wait "$REC_PID" 2>/dev/null || true

# Run songrec recognition
RESULT=$(songrec audio-file-to-recognized-song "$TMP_WAV" 2>/dev/null || true)

if [ -z "$RESULT" ]; then
    notify-send -t 3000 -a "Shazam" "❌ No Match Found" "Could not identify the song. Try increasing volume."
    exit 0
fi

TITLE=$(echo "$RESULT" | grep -oP '"title":\s*"\K[^"]+' | head -n 1 || true)
ARTIST=$(echo "$RESULT" | grep -oP '"subtitle":\s*"\K[^"]+' | head -n 1 || true)

if [ -n "$TITLE" ]; then
    if [ -n "$ARTIST" ]; then
        notify-send -t 6000 -a "Shazam" "🎵 Track Identified!" "$TITLE by $ARTIST"
        echo "$TITLE - $ARTIST" | wl-copy
    else
        notify-send -t 6000 -a "Shazam" "🎵 Track Identified!" "$TITLE"
        echo "$TITLE" | wl-copy
    fi
else
    notify-send -t 4000 -a "Shazam" "🎵 Shazam Result" "$RESULT"
fi
