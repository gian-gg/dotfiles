#!/bin/zsh
# Target display for the bar: the second display when present, else the main one.

SKETCHYBAR=/opt/homebrew/bin/sketchybar
AEROSPACE=/opt/homebrew/bin/aerospace

pick_target() {
  local count
  count="$($AEROSPACE list-monitors --count 2>/dev/null)"
  if [[ "$count" == <-> && "$count" -ge 2 ]]; then print -r -- 2; else print -r -- main; fi
}

if [[ -n "$NAME" ]]; then
  $SKETCHYBAR --bar display="$(pick_target)"
  # Re-apply after displays settle following wake or hotplug.
  sleep 3
  $SKETCHYBAR --bar display="$(pick_target)"
else
  pick_target
fi
