#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  sketchybar --set "$NAME" label="[ ${INFO} ]"
  exit 0
fi

USER_NAME="$(whoami)"
HOST_NAME="$(scutil --get LocalHostName 2>/dev/null)"

if [ -z "$HOST_NAME" ]; then
  HOST_NAME="$(hostname -s 2>/dev/null)"
fi

if [ -z "$HOST_NAME" ]; then
  HOST_NAME="host"
fi

sketchybar --set "$NAME" label="[ ${USER_NAME}@${HOST_NAME}:~ ]"
