#!/usr/bin/env bash
set -euo pipefail

MON="DP-1"
WS="4"
URL="https://chat.openai.com"

jump() {
  hyprctl dispatch focusmonitor "$MON" >/dev/null
  hyprctl dispatch workspace "$WS" >/dev/null
}

# Returns 0 if a firefox window exists on workspace 4, else 1
firefox_on_ws() {
  hyprctl clients | awk -v ws="$WS" '
    /^Window/ {
      # evaluate previous block before starting a new one
      if (seen && class=="firefox" && wsid==ws) found=1
      seen=1; class=""; wsid=""
    }
    /^[[:space:]]*class:[[:space:]]*/ { class=$2 }
    /^[[:space:]]*workspace:[[:space:]]*/ { wsid=$2 }
    END {
      if (seen && class=="firefox" && wsid==ws) found=1
      exit(found ? 0 : 1)
    }
  '
}

jump

# If it's already there, just focus it (and DO NOT spawn)
if firefox_on_ws; then
  # Try to focus a firefox window (you’re already on ws4 on DP-1)
  hyprctl dispatch focuswindow 'class:^(firefox)$' >/dev/null 2>&1 || true
  exit 0
fi

# Otherwise spawn it on ws4
hyprctl dispatch exec "[workspace ${WS} silent] /usr/bin/firefox --new-window ${URL}" >/dev/null 2>&1

