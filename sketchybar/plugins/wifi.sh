#!/bin/bash

# TUI palette (keep in sync with sketchybarrc)
PRIMARY_COLOR="0xffffffff"
MUTED_COLOR="0xffded8cf"

# Prefer the default route interface
WIFI_DEVICE="$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')"

# Fallback: probe common interfaces
if [ -z "$WIFI_DEVICE" ]; then
  for interface in en0 en1 en2; do
    if ifconfig "$interface" 2>/dev/null | grep -q "status: active"; then
      WIFI_DEVICE="$interface"
      break
    fi
  done
fi

if [ -n "$WIFI_DEVICE" ] && ifconfig "$WIFI_DEVICE" 2>/dev/null | grep -q "status: active"; then
  ICON="󰖩"
  LABEL="[ ${ICON} ]"
  COLOR="$PRIMARY_COLOR"
else
  ICON="󰖪"
  LABEL="[ ${ICON} ]"
  COLOR="$MUTED_COLOR"
fi

sketchybar --set "$NAME" label="$LABEL" label.color="$COLOR"
