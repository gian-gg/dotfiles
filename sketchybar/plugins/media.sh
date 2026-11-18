#!/bin/bash

# Now-playing track from nowplaying-cli, Spotify, Music, or a YouTube tab in Zen.

. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"
TITLE=""
ARTIST=""
STATE=""

NOWPLAYING_BIN="$(command -v nowplaying-cli 2>/dev/null)"
if [ -n "$NOWPLAYING_BIN" ]; then
    NOWPLAYING_OUTPUT="$("$NOWPLAYING_BIN" get title artist playbackRate 2>/dev/null || true)"
    TITLE="$(printf "%s\n" "$NOWPLAYING_OUTPUT" | sed -n '1p')"
    ARTIST="$(printf "%s\n" "$NOWPLAYING_OUTPUT" | sed -n '2p')"
    PLAYBACK_RATE="$(printf "%s\n" "$NOWPLAYING_OUTPUT" | sed -n '3p')"

    if [ "$TITLE" = "null" ]; then
        TITLE=""
    fi
    if [ "$ARTIST" = "null" ]; then
        ARTIST=""
    fi

    if [ "$PLAYBACK_RATE" = "0" ]; then
        STATE="paused"
    elif [ "$PLAYBACK_RATE" = "1" ]; then
        STATE="playing"
    fi
fi

# Check Spotify first if running
if [ -z "$TITLE" ] && pgrep -x "Spotify" > /dev/null 2>&1; then
    STATE=$(osascript -e 'tell application "Spotify" to get player state as string' 2>/dev/null)
    if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
        TITLE=$(osascript -e 'tell application "Spotify" to get name of current track' 2>/dev/null)
        ARTIST=$(osascript -e 'tell application "Spotify" to get artist of current track' 2>/dev/null)
    fi
fi

# Check Music if no Spotify or if Spotify returned nothing
if [ -z "$TITLE" ] && pgrep -x "Music" > /dev/null 2>&1; then
    STATE=$(osascript -e 'tell application "Music" to get player state as string' 2>/dev/null)
    if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
        TITLE=$(osascript -e 'tell application "Music" to get name of current track' 2>/dev/null)
        ARTIST=$(osascript -e 'tell application "Music" to get artist of current track' 2>/dev/null)
    fi
fi

# Zen YouTube tab via window title
if [ -z "$TITLE" ] && pgrep -x "zen" > /dev/null 2>&1; then
    WINDOW_TITLE="$(osascript -e 'tell application "System Events" to tell process "Zen" to get name of front window' 2>/dev/null)"
    case "$WINDOW_TITLE" in
        *" - YouTube")
            TITLE="${WINDOW_TITLE% - YouTube}"
            STATE="playing"
            ;;
    esac
fi

# If we have a title, display it
if [ -n "$TITLE" ]; then
    # Format: Artist - Title
    if [ -n "$ARTIST" ]; then
        DISPLAY_TEXT="$ARTIST - $TITLE"
    else
        DISPLAY_TEXT="$TITLE"
    fi
    
    # Set icon based on state
    if [ "$STATE" = "playing" ]; then
        ICON="$ICON_PLAY"
        COLOR=$ACCENT
    else
        ICON="$ICON_PAUSE"
        COLOR=$MUTED
    fi

    sketchybar --set "$NAME" \
        icon="$ICON" \
        icon.color="$COLOR" \
        label="$DISPLAY_TEXT" \
        label.drawing=on \
        label.color="$MUTED" \
        drawing=on
else
    # Nothing playing - hide the item
    sketchybar --set "$NAME" drawing=off
fi
