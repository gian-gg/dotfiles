#!/bin/bash
# Workspace dots 1-6 like the Dock: focused large and white, occupied medium, empty faint.

. "$CONFIG_DIR/colors.sh"

AEROSPACE=/opt/homebrew/bin/aerospace

FOCUSED="${FOCUSED_WORKSPACE:-$("$AEROSPACE" list-workspaces --focused 2>/dev/null)}"
OCCUPIED=" $("$AEROSPACE" list-windows --all --format '%{workspace}' 2>/dev/null | sort -u | tr '\n' ' ') "

args=()
for i in 1 2 3 4 5 6; do
  if [ "$i" = "$FOCUSED" ]; then
    args+=(--set "workspace.$i" icon.font="SF Pro:Medium:9.0" icon.color="$TEXT")
  elif [[ "$OCCUPIED" == *" $i "* ]]; then
    args+=(--set "workspace.$i" icon.font="SF Pro:Medium:6.0" icon.color="$DOT_FILLED")
  else
    args+=(--set "workspace.$i" icon.font="SF Pro:Medium:6.0" icon.color="$DIM")
  fi
done

sketchybar --animate tanh 12 "${args[@]}"
