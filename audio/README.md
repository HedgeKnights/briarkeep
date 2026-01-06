# Bluetooth Audio Autoswitch

Purpose:
Automatically switch default PipeWire audio sink when Bluetooth earbuds
(Pixel Buds) connect, and revert to the primary headset when they disconnect.

Components:
- bt-audio-autoswitch.sh
  Logic for detecting connected devices and setting default sink via wpctl.
- bt-audio-autoswitch.service
  systemd --user service that runs the autoswitch logic.

Notes:
- Designed for PipeWire + WirePlumber
- Triggered manually or by systemd (event-based logic TBD)

