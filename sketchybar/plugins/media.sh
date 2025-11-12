#!/bin/bash

# Get currently playing media from any source
TITLE=""
ARTIST=""
STATE=""

# Check Spotify first if running
if pgrep -x "Spotify" > /dev/null 2>&1; then
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

# If we have a title, display it
if [ -n "$TITLE" ]; then
    # Format: Artist – Title
    if [ -n "$ARTIST" ]; then
        DISPLAY_TEXT="$ARTIST – $TITLE"
    else
        DISPLAY_TEXT="$TITLE"
    fi
    
    # Truncate if too long
    MAX_LENGTH=35
    if [ ${#DISPLAY_TEXT} -gt $MAX_LENGTH ]; then
        DISPLAY_TEXT="${DISPLAY_TEXT:0:$MAX_LENGTH}..."
    fi
    
    # Set icon and color based on state
    if [ "$STATE" = "playing" ]; then
        ICON="󰐊"
        COLOR="0xff66bb6a"
    else
        ICON="󰏤"
        COLOR="0xffffb74d"
    fi
    
    sketchybar --set "$NAME" \
        icon="$ICON" \
        label="$DISPLAY_TEXT" \
        icon.color="$COLOR" \
        label.drawing=on \
        drawing=on
else
    # Nothing playing - hide the item
    sketchybar --set "$NAME" drawing=off
fi