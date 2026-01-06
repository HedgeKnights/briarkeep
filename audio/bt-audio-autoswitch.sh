#!/usr/bin/env bash
set -euo pipefail

BUDS_MAC="98:3A:1F:EC:AC:B7"
BUDS_PATH="/org/bluez/hci0/dev_${BUDS_MAC//:/_}"

# Remember current default sink at startup as fallback
FALLBACK_SINK="$(pactl info | awk -F': ' '/Default Sink/ {print $2}')"

pick_buds_sink() {
  pactl list short sinks | awk '{print $2}' | grep -E "^bluez_output\.98_3A_1F_EC_AC_B7" | head -n1 || true
}

move_all_streams_to_default() {
  local def
  def="$(pactl info | awk -F': ' '/Default Sink/ {print $2}')"
  pactl list short sink-inputs | awk '{print $1}' | while read -r id; do
    pactl move-sink-input "$id" "$def" >/dev/null 2>&1 || true
  done
}

switch_to_buds() {
  local buds_sink
  buds_sink="$(pick_buds_sink)"
  [[ -n "$buds_sink" ]] || return 0
  pactl set-default-sink "$buds_sink"
  move_all_streams_to_default
}

switch_to_fallback() {
  # If fallback disappeared, re-read current default
  if ! pactl list short sinks | awk '{print $2}' | grep -qx "$FALLBACK_SINK"; then
    FALLBACK_SINK="$(pactl info | awk -F': ' '/Default Sink/ {print $2}')"
  fi
  pactl set-default-sink "$FALLBACK_SINK"
  move_all_streams_to_default
}
# Listen for BlueZ PropertiesChanged on the Pixel Buds device object
gdbus monitor --system \
  --dest org.bluez \
  --object-path "$BUDS_PATH" \
| while read -r line; do
    # We only care about changes to the Connected property
    if [[ "$line" == *"Connected"* && "$line" == *"true"* ]]; then
      sleep 0.5
      switch_to_buds
    elif [[ "$line" == *"Connected"* && "$line" == *"false"* ]]; then
      # Let BlueZ/PipeWire settle; Spotify is sensitive to rapid route changes
      sleep 1
      switch_to_fallback
      # Some apps need a second move after the new default is fully ready
      sleep 0.5
      move_all_streams_to_default
    fi
  done

