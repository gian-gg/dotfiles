#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾"
    ;;
    [3-5][0-9]) ICON="󰖀"
    ;;
    [1-9]|[1-2][0-9]) ICON="󰕿"
    ;;
    *) ICON="󰖁"
  esac

  LABEL="[ ${ICON} ${VOLUME}% ]"

  if [ "$VOLUME" = "0" ]; then
    sketchybar --set "$NAME" label="$LABEL" label.color="0xffea7d7d"
  else
    sketchybar --set "$NAME" label="$LABEL" label.color="0xfff2f0f5"
  fi
fi
