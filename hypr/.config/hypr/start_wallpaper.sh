#!/bin/bash

pkill awww-daemon

awww-daemon &

sleep 1

awww img --transition-type fade ~/Pictures/wallpapers/RWBB.JPG
