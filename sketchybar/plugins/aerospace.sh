#!/usr/bin/env bash

# --- Material UI Islands Colors ---
# These values are from your sketchybarcc.
# We define them here so the script knows what to use.

PRIMARY=0xffc4b5fd     # Pastel Purple (oklch(0.78 0.14 285))
PRIMARY_FG=0xff1f1f1f  # Dark text, for high contrast on Primary bg
BG_CARD=0xff303030     # Dark island background

# Check if the workspace ($1) is the one currently focused
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  # FOCUSED STATE:
  # Set the island background to the PRIMARY color
  # and the icon to the high-contrast PRIMARY_FG color.
  sketchybar --set $NAME \
             background.color=$PRIMARY \
             icon.color=$PRIMARY_FG
else
  # UNFOCUSED STATE:
  # Revert to the default dark island (BG_CARD)
  # and the default icon color (PRIMARY).
  sketchybar --set $NAME \
             background.color=$BG_CARD \
             icon.color=$PRIMARY
fi
