#!/bin/sh
# Output volume icon; muted shows dimmed.

. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

if [ "$SENDER" = "volume_change" ] && [ -n "$INFO" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi
[ -z "$VOLUME" ] && exit 0

case "$VOLUME" in
  [6-9][0-9]|100)  ICON="$ICON_VOL_3" ;;
  [3-5][0-9])      ICON="$ICON_VOL_2" ;;
  [1-9]|[1-2][0-9]) ICON="$ICON_VOL_1" ;;
  *)               ICON="$ICON_VOL_0" ;;
esac

COLOR=$TEXT
[ "$VOLUME" = "0" ] && COLOR=$MUTED

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
