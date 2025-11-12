#!/bin/sh
# (This is the new content for clock.sh)

sketchybar --set "$NAME" \
           icon="󰥔" \
           label="$(date '+%a %d %b  %H:%M:%S')"