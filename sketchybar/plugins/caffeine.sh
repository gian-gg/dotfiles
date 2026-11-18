#!/bin/sh
# Coffee icon showing whether anything is keeping the Mac awake; click toggles the bar's own caffeinate.

. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

NAME="${NAME:-caffeine}"
PID_FILE="${TMPDIR:-/tmp}/sketchybar-caffeinate.pid"

own_pid() {
  pid="$(cat "$PID_FILE" 2>/dev/null)"
  [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null && [ "$(ps -o comm= -p "$pid")" = "caffeinate" ] && echo "$pid"
}

if [ "$1" = "toggle" ]; then
  pid="$(own_pid)"
  if [ -n "$pid" ]; then
    kill "$pid"
    rm -f "$PID_FILE"
  else
    nohup caffeinate -dis >/dev/null 2>&1 &
    echo $! > "$PID_FILE"
  fi
  sleep 0.2
fi

if pgrep -xq caffeinate \
  || pmset -g assertions | grep -Eiq '(amphetamine|keepingyouawake|theine|lungo).*Prevent(UserIdle|System)'; then
  ICON="$ICON_CUP_FILL"
  COLOR=$ACCENT
else
  ICON="$ICON_CUP"
  COLOR=$MUTED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
