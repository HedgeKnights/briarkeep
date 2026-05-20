
#!/usr/bin/env bash
set -euo pipefail

BUDS_MAC="98:3A:1F:EC:AC:B7"
BUDS_PATH="/org/bluez/hci0/dev_${BUDS_MAC//:/_}"
BUDS_SINK_PREFIX="bluez_output.${BUDS_MAC//:/_}"
FALLBACK_SINK=""

log() {
  printf '[bt-audio-autoswitch] %s\n' "$*"
}

current_default_sink() {
  pactl info | awk -F': ' '/Default Sink/ {print $2}'
}

update_fallback_sink() {
  local cur
  cur="$(current_default_sink)"

  # Do not overwrite fallback with the buds themselves.
  [[ "$cur" == ${BUDS_SINK_PREFIX}* ]] && return
  [[ -n "$cur" ]] && FALLBACK_SINK="$cur"
}

pick_buds_sink() {
  local mac_colon="$BUDS_MAC"
  local mac_us="${BUDS_MAC//:/_}"

  pactl list short sinks | awk '{print $2}' \
    | grep -E "^bluez_output\.(${mac_colon}|${mac_us})([._].*)?$" \
    | head -n1 || true
}

move_all_streams_to_default() {
  local def
  def="$(current_default_sink)"
  [[ -n "$def" ]] || return 0

  pactl list short sink-inputs | awk '{print $1}' | while read -r id; do
    [[ -n "$id" ]] || continue
    pactl move-sink-input "$id" "$def" >/dev/null 2>&1 || true
  done
}

switch_to_buds() {
  update_fallback_sink

  local buds_sink=""
  for _ in {1..20}; do
    buds_sink="$(pick_buds_sink)"
    [[ -n "$buds_sink" ]] && break
    sleep 0.5
  done

  [[ -n "$buds_sink" ]] || {
    log "No Pixel Buds sink found yet"
    return 0
  }

  local cur
  cur="$(current_default_sink)"
  if [[ "$cur" == "$buds_sink" ]]; then
    log "Pixel Buds sink already default: $buds_sink"
    return 0
  fi

  log "Switching default sink to: $buds_sink"
  pactl set-default-sink "$buds_sink"
  move_all_streams_to_default
}

switch_to_fallback() {
  [[ -n "$FALLBACK_SINK" ]] || {
    log "No fallback sink recorded"
    return 0
  }

  local cur
  cur="$(current_default_sink)"
  if [[ "$cur" == "$FALLBACK_SINK" ]]; then
    log "Fallback sink already default: $FALLBACK_SINK"
    return 0
  fi

  log "Switching back to fallback sink: $FALLBACK_SINK"
  pactl set-default-sink "$FALLBACK_SINK"
  move_all_streams_to_default
}

# If the buds are already connected when the service starts, give PipeWire
# a few chances to expose the sink before giving up.
for _ in {1..6}; do
  switch_to_buds
  sleep 1
done

# Listen for BlueZ PropertiesChanged on the Pixel Buds device object.
# On connect, retry a few times because PipeWire can lag behind BlueZ.
# On disconnect, restore the previous default sink.
gdbus monitor --system \
  --dest org.bluez \
  --object-path "$BUDS_PATH" \
| while read -r line; do
    if [[ "$line" == *"Connected"* && "$line" == *"true"* ]]; then
      log "Pixel Buds connected"
      for _ in {1..3}; do
        sleep 1
        switch_to_buds
      done
    elif [[ "$line" == *"Connected"* && "$line" == *"false"* ]]; then
      log "Pixel Buds disconnected"
      sleep 2
      switch_to_fallback
      sleep 0.5
      move_all_streams_to_default
    fi
  done

