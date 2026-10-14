#!/bin/bash

# Spotify Play/Pause Toggle Script for Niri / CachyOS
# Handles starting Spotify if not running, or toggling play/pause via MPRIS DBus with desktop notification.

# Check if Spotify is running or if its MPRIS interface is active
if ! busctl --user list | grep -q "org.mpris.MediaPlayer2.spotify"; then
    notify-send -i "spotify" "🟢 Spotify" "Starting Spotify..." --expire-time=2000
    spotify-launcher > /dev/null 2>&1 &
    
    # Wait up to 6 seconds for Spotify's MPRIS interface to initialize
    for _ in {1..24}; do
        if busctl --user list | grep -q "org.mpris.MediaPlayer2.spotify"; then
            sleep 0.6
            dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
            break
        fi
        sleep 0.25
    done
    exit 0
fi

# Toggle Play/Pause
dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause

# Brief pause for status change
sleep 0.15

# Fetch new playback status
STATUS=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"PlaybackStatus" 2>/dev/null | awk -F '"' '/string/ {print $2}')

if [ "$STATUS" = "Playing" ]; then
    TITLE=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" 2>/dev/null | grep -A 1 "xesam:title" | awk -F '"' '/string/ {print $2}')
    ARTIST=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" 2>/dev/null | grep -A 2 "xesam:artist" | awk -F '"' '/string/ {print $2}' | tail -n 1)

    if [ -n "$TITLE" ]; then
        notify-send -i "spotify" "▶️ Spotify Playing" "$TITLE — $ARTIST" --expire-time=2500
    else
        notify-send -i "spotify" "▶️ Spotify Playing" "Resumed playback" --expire-time=2000
    fi
else
    notify-send -i "spotify" "⏸️ Spotify Paused" "Playback paused" --expire-time=2000
fi
