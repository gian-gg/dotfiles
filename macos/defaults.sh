#!/bin/bash
# macOS system settings: hidden dock, flatter window corners, keyboard and UI tweaks.

# Dock: auto-hide with a delay long enough that it never appears
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock tilesize -int 35

# Window corners
defaults write -g NSConvolutionOverride1 -float 0

# Appearance
defaults write -g AppleInterfaceStyle -string Dark
defaults write -g AppleIconAppearanceTheme -string ClearDark
defaults write -g AppleIconAppearanceTintColor -string Graphite
defaults write -g AppleAccentColor -int -1
defaults write -g AppleHighlightColor -string "0.847059 0.847059 0.862745 Graphite"
defaults write -g AppleMenuBarVisibleInFullscreen -bool false

# Keyboard
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Windows and Finder
defaults write -g AppleShowAllExtensions -bool true
defaults write -g AppleShowScrollBars -string WhenScrolling
defaults write -g AppleWindowTabbingMode -string always
defaults write -g AppleActionOnDoubleClick -string Fill

# Cursor: no shake-to-enlarge
defaults write -g CGDisableCursorLocationMagnification -bool true

killall Dock
echo "Done. Log out and back in for global settings to apply."
