#!/bin/bash

# Kill any old instances
pkill swww-daemon

# Start the daemon
swww-daemon &

# Wait 1 second for the daemon to initialize its socket
sleep 1

# Apply the wallpaper
swww img /home/hedgekinght/.config/hypr/wallpapers/mtdoom.jpg --transition-type simple
