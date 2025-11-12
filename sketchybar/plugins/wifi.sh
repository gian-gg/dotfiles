#!/bin/bash

# Check wifi status across multiple interfaces
WIFI_DEVICE=""
WIFI_SSID=""

# Try common wifi interfaces
for interface in en0 en1 en2; do
    # Check if interface has an IP address (connected to network)
    if ifconfig "$interface" 2>/dev/null | grep -q "inet "; then
        # Try to get SSID
        SSID=$(networksetup -getairportnetwork "$interface" 2>/dev/null | sed 's/Current Wi-Fi Network: //')
        
        if [ "$SSID" != "You are not associated with an AirPort network." ] && [ -n "$SSID" ]; then
            WIFI_DEVICE="$interface"
            WIFI_SSID="$SSID"
            break
        fi
    fi
done

# If networksetup failed but we have an IP, assume connected
if [ -z "$WIFI_SSID" ]; then
    for interface in en0 en1 en2; do
        if ifconfig "$interface" 2>/dev/null | grep -q "inet "; then
            WIFI_SSID="Connected"
            break
        fi
    done
fi

if [ -n "$WIFI_SSID" ]; then
    sketchybar --set $NAME \
        icon=󰖩 \
        icon.color=0xff66bb6a \
        label="$WIFI_SSID" \
        label.drawing=on
else
    sketchybar --set $NAME \
        icon=󰖪 \
        icon.color=0xffef5350 \
        label="Disconnected" \
        label.drawing=on
fi
