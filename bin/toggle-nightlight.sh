#!/bin/bash

if pgrep -x wlsunset >/dev/null; then
    pkill -x wlsunset
    notify-send -t 2000 -a "Night Light" "☀️ Night Light: OFF" "Color temperature restored to normal."
else
    wlsunset -t 4000 -T 4001 &
    notify-send -t 2000 -a "Night Light" "🌙 Night Light: ON" "Warm 4000K filter active."
fi
