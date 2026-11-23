#!/usr/bin/env bash
set -euo pipefail

GEMINI_URL="https://gemini.google.com/app"
APP_ID_REGEX='^chrome-gemini\.google\.com'

win_json=$(niri msg --json windows | jq -c --arg re "$APP_ID_REGEX" \
  '[.[] | select((.app_id // "") | test($re))] | first // empty')

if [[ -n "$win_json" ]]; then
  win_id=$(jq -r '.id' <<<"$win_json")
  win_ws=$(jq -r '.workspace_id' <<<"$win_json")
  is_focused=$(jq -r '.is_focused' <<<"$win_json")

  cur_ws_json=$(niri msg --json workspaces | jq -c '[.[] | select(.is_focused == true)] | first')
  cur_ws_id=$(jq -r '.id' <<<"$cur_ws_json")
  cur_ws_idx=$(jq -r '.idx' <<<"$cur_ws_json")
  cur_output=$(jq -r '.output' <<<"$cur_ws_json")

  if [[ "$win_ws" != "$cur_ws_id" ]]; then
    niri msg action move-window-to-monitor --id "$win_id" "$cur_output" >/dev/null 2>&1 || true
    niri msg action move-window-to-workspace --window-id "$win_id" --focus true "$cur_ws_idx" >/dev/null 2>&1 || true
  fi

  if [[ "$is_focused" != "true" ]]; then
    niri msg action focus-window --id "$win_id" >/dev/null 2>&1 || true
  fi
  exit 0
fi

if command -v helium-browser >/dev/null 2>&1; then
  nohup helium-browser --app="$GEMINI_URL" >/dev/null 2>&1 &
elif command -v chromium >/dev/null 2>&1; then
  nohup chromium --app="$GEMINI_URL" >/dev/null 2>&1 &
else
  nohup xdg-open "$GEMINI_URL" >/dev/null 2>&1 &
fi
