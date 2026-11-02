#!/bin/bash

# Spotify Next Track Script for Niri / CachyOS
if ! busctl --user list | grep -q "org.mpris.MediaPlayer2.spotify"; then
    notify-send -i "spotify" "Spotify" "Spotify is not running" --expire-time=1500
    exit 0
fi

# Send MPRIS Next command
dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next

# Allow Spotify a moment to update metadata
sleep 0.2

# Extract updated title and artist
TITLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" 2>/dev/null | grep -A 1 "xesam:title" | tail -n 1 | cut -d '"' -f 2)
ARTIST=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" 2>/dev/null | grep -A 2 "xesam:artist" | tail -n 1 | cut -d '"' -f 2)

if [ -n "$TITLE" ]; then
    notify-send -i "spotify" "⏭️ Spotify Next" "$TITLE ($ARTIST)" --expire-time=2000
else
    notify-send -i "spotify" "⏭️ Spotify Next" "Switched to next track" --expire-time=1500
fi
