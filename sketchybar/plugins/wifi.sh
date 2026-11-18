#!/bin/sh
# Network status icon for the default-route interface.

. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

DEVICE="$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')"

if [ -n "$DEVICE" ] && ifconfig "$DEVICE" 2>/dev/null | grep -q "status: active"; then
  ICON="$ICON_WIFI"
  COLOR=$TEXT
else
  ICON="$ICON_WIFI_OFF"
  COLOR=$ACCENT
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
