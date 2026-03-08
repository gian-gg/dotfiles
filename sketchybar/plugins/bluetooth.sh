#!/bin/sh

PRIMARY_COLOR="0xffffffff"
FG_PRIMARY="0xffded8cf"

POWER_STATE="$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null)"
if [ -z "$POWER_STATE" ]; then
  POWER_STATE="$(defaults read "$HOME/Library/Preferences/ByHost/com.apple.Bluetooth" ControllerPowerState 2>/dev/null)"
fi
if [ -z "$POWER_STATE" ]; then
  POWER_STATE="$(system_profiler SPBluetoothDataType 2>/dev/null | awk -F': ' '/Bluetooth Power/ {print $2; exit}')"
fi
if [ -z "$POWER_STATE" ]; then
  POWER_STATE="$(system_profiler SPBluetoothDataType 2>/dev/null | awk -F': ' '/State/ {print $2; exit}')"
fi

if [ "$POWER_STATE" = "1" ] || [ "$POWER_STATE" = "On" ] || [ "$POWER_STATE" = "Enabled" ]; then
  ICON="󰂯"
  COLOR="$PRIMARY_COLOR"
  CONNECTED_DEVICES="$(system_profiler SPBluetoothDataType 2>/dev/null | awk -F': ' '
    /Device Name/ {name=$2}
    /Connected: Yes/ && name {print name; name=""}
  ')"
  if [ -n "$CONNECTED_DEVICES" ]; then
    COUNT="$(printf "%s\n" "$CONNECTED_DEVICES" | wc -l | tr -d ' ')"
    if [ "$COUNT" = "1" ]; then
      DEVICE_NAME="$(printf "%s\n" "$CONNECTED_DEVICES" | head -n 1)"
      LABEL="[ ${ICON} ${DEVICE_NAME} ]"
    else
      LABEL="[ ${ICON} ${COUNT} ]"
    fi
  else
    LABEL="[ ${ICON} ]"
  fi
else
  ICON="󰂲"
  COLOR="$FG_PRIMARY"
  LABEL="[ ${ICON} ]"
fi

sketchybar --set "$NAME" label="$LABEL" label.color="$COLOR"
