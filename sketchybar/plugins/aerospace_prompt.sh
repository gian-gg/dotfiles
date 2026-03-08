#!/usr/bin/env bash

set -u

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
AEROSPACE_BIN="${AEROSPACE_BIN:-$(command -v aerospace || true)}"
if [ -z "$AEROSPACE_BIN" ]; then
  for candidate in /opt/homebrew/bin/aerospace /usr/local/bin/aerospace /usr/bin/aerospace; do
    if [ -x "$candidate" ]; then
      AEROSPACE_BIN="$candidate"
      break
    fi
  done
fi

if [ -z "$AEROSPACE_BIN" ]; then
  sketchybar --set "$NAME" label="[ - | - ]"
  exit 0
fi

if ! "$AEROSPACE_BIN" list-workspaces --focused >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="[ - | - ]"
  exit 0
fi

ACTIVE_SPACES=""
OCCUPIED_SPACES=""

append_unique() {
  local list="$1"
  local value="$2"
  case " $list " in
    *" $value "*) printf "%s" "$list" ;;
    *) printf "%s%s%s" "$list" "${list:+ }" "$value" ;;
  esac
}

if [ -n "${FOCUSED_WORKSPACE:-}" ]; then
  ACTIVE_SPACES="$(append_unique "$ACTIVE_SPACES" "$FOCUSED_WORKSPACE")"
fi

if [ -z "$ACTIVE_SPACES" ]; then
  ACTIVE_SPACES="$("$AEROSPACE_BIN" list-workspaces --focused 2>/dev/null | tr '\n' ' ' | xargs 2>/dev/null || true)"
fi

if [ -z "$ACTIVE_SPACES" ]; then
  for mid in $("$AEROSPACE_BIN" list-monitors 2>/dev/null | cut -c1); do
    for sid in $("$AEROSPACE_BIN" list-workspaces --monitor "$mid" --visible yes 2>/dev/null); do
      ACTIVE_SPACES="$(append_unique "$ACTIVE_SPACES" "$sid")"
    done
  done
fi

for sid in $("$AEROSPACE_BIN" list-workspaces --all 2>/dev/null); do
  if "$AEROSPACE_BIN" list-windows --workspace "$sid" | head -n 1 | grep -q .; then
    OCCUPIED_SPACES="$(append_unique "$OCCUPIED_SPACES" "$sid")"
  fi
done

if [ -z "$ACTIVE_SPACES" ]; then
  ACTIVE_SPACES="-"
fi

if [ -z "$OCCUPIED_SPACES" ]; then
  OCCUPIED_SPACES="-"
fi

sketchybar --set aerospace.active label="$ACTIVE_SPACES"
sketchybar --set aerospace.occupied label="$OCCUPIED_SPACES"
