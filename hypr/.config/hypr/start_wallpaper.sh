#!/bin/bash

# Kill any old instances
pkill swww-daemon

# Start the daemon
swww-daemon &

# Wait 1 second for the daemon to initialize its socket
sleep 1

swww img ~/Pictures/wallpapers/RWBB.jpg --transition-type simple
