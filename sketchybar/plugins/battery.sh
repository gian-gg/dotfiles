#!/bin/sh
# Battery percentage with a charge-level icon.

. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

BATT="$(pmset -g batt)"
PERCENTAGE="$(printf '%s' "$BATT" | grep -Eo '[0-9]+%' | cut -d% -f1)"
[ -z "$PERCENTAGE" ] && exit 0

case "$PERCENTAGE" in
  9[0-9]|100) ICON="$ICON_BAT_100" ;;
  [6-8][0-9]) ICON="$ICON_BAT_75" ;;
  [3-5][0-9]) ICON="$ICON_BAT_50" ;;
  [1-2][0-9]) ICON="$ICON_BAT_25" ;;
  *)          ICON="$ICON_BAT_0" ;;
esac

COLOR=$TEXT
if printf '%s' "$BATT" | grep -q 'AC Power'; then
  ICON="$ICON_BAT_CHARGING"
elif [ "$PERCENTAGE" -le 15 ]; then
  COLOR=$ACCENT
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%" label.color="$COLOR"
