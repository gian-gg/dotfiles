#!/bin/sh
# Date and time with a blinking separator.

if [ $(( $(date '+%s') % 2 )) -eq 0 ]; then
  TIME="$(date '+%H:%M:%S')"
else
  TIME="$(date '+%H:%M:%S' | tr ':' ' ')"
fi

sketchybar --set clock label="$TIME" \
           --set date label="$(date '+%a · %b %d')"
