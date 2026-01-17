#!/usr/bin/env bash
set -euo pipefail

MON="DP-1"
WS="5"
CLASS_REGEX='class:^(spotify)$'

jump_to_ws() {
  hyprctl dispatch focusmonitor "$MON" >/dev/null
  hyprctl dispatch workspace "$WS" >/dev/null
}

spotify_running() {
  pgrep -x spotify >/dev/null 2>&1 || pgrep -f 'spotify-launcher' >/dev/null 2>&1
}

focus_spotify() {
  hyprctl dispatch focuswindow "$CLASS_REGEX" >/dev/null 2>&1 || true
}

if spotify_running; then
  jump_to_ws
  focus_spotify
  exit 0
fi

jump_to_ws
(spotify-launcher >/dev/null 2>&1 &)

for _ in {1..30}; do
  if hyprctl dispatch focuswindow "$CLASS_REGEX" >/dev/null 2>&1; then
    exit 0
  fi
  sleep 0.1
done

