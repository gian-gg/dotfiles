#!/bin/bash
# Running apps in launch order, left of gap.media; Apple logo when empty.

. "$CONFIG_DIR/icons.sh"

ICONS="$CONFIG_DIR/cache/appicons-island"
STATE="$CONFIG_DIR/cache/open_apps"
CELL=32
CANVAS=96
IMAGE_SCALE=0.3333
IDLE_ALPHA=0.45
ANCHOR=gap.media

running_apps() {
  lsappinfo list | awk -F'"' '
    /^ *[0-9]+\) /   { bundle = "" }
    /bundleID="/     { bundle = $2 }
    /type="Foreground"/ { if (bundle != "" && bundle != "com.apple.finder") print bundle }'
}

front_bundle() {
  lsappinfo info -only bundleid "$(lsappinfo front)" 2>/dev/null | awk -F'"' '{print $4}'
}

rebuild() {
  local apps="$1" bundle icon item count=0
  local args=(--remove '/^island\./')

  while IFS= read -r bundle; do
    [ -n "$bundle" ] || continue
    icon="$ICONS/$bundle.png"
    [ -f "$icon" ] || "$CONFIG_DIR/bin/appicon" "$bundle" "$icon" $CANVAS || continue
    [ -f "$ICONS/$bundle.idle.png" ] || "$CONFIG_DIR/bin/appicon" "$bundle" "$ICONS/$bundle.idle.png" $CANVAS $IDLE_ALPHA || continue
    item="island.app.$bundle"
    args+=(--add item "$item" left
      --set "$item"
        width=$CELL
        icon.drawing=off
        label.drawing=off
        background.drawing=on
        background.image="$ICONS/$bundle.idle.png"
        background.image.scale=$IMAGE_SCALE
        background.image.drawing=on
        click_script="open -b '$bundle'"
      --move "$item" before $ANCHOR)
    count=$((count + 1))
  done <<< "$apps"

  if [ $count -eq 0 ]; then
    args+=(--add item island.apple left
      --set island.apple
        width=$CELL
        icon="$ICON_APPLE"
        icon.font="SF Pro:Medium:14.0"
        icon.width=$CELL
        icon.align=center
        icon.y_offset=1
        label.drawing=off
      --move island.apple before $ANCHOR)
  fi

  sketchybar "${args[@]}"
}

highlight() {
  local apps="$1" front="$2" bundle image
  local args=()
  while IFS= read -r bundle; do
    [ -n "$bundle" ] || continue
    image="$ICONS/$bundle.idle.png"
    [ "$bundle" = "$front" ] && image="$ICONS/$bundle.png"
    args+=(--set "island.app.$bundle" background.image="$image" background.image.scale=$IMAGE_SCALE)
  done <<< "$apps"
  [ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
}

APPS="$(running_apps)"
FRONT="$(front_bundle)"
LAST="$(cat "$STATE" 2>/dev/null)"

if [ "$APPS" != "$LAST" ] || [ "$SENDER" = "forced" ]; then
  rebuild "$APPS"
  printf '%s' "$APPS" > "$STATE"
  LAST_FRONT=""
else
  LAST_FRONT="$(cat "$STATE.front" 2>/dev/null)"
fi

if [ "$FRONT" != "$LAST_FRONT" ]; then
  highlight "$APPS" "$FRONT"
  printf '%s' "$FRONT" > "$STATE.front"
fi
