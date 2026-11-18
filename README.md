# macos dotfiles

Personal configuration files.

| folder | goes to |
|---|---|
| `sketchybar/` | `~/.config/sketchybar/` |
| `aerospace/.aerospace.toml` | `~/.aerospace.toml` |
| `borders/` | `~/.config/borders/` |
| `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `ghostty/shaders*` | `~/.config/ghostty/` |
| `fastfetch/` | `~/.config/fastfetch/` |
| `zed/` | `~/.config/zed/` |
| `zsh/` | `~/` (oh-my-zsh + powerlevel10k) |
| `macursor/` | import into [MaCursor](https://formulae.brew.sh/cask/macursor) |
| `macos/defaults.sh` | run once |

## setup notes

- sketchybar app icons: `swiftc -O bin/appicon.swift -o bin/appicon && mkdir -p cache/appicons-island` inside `~/.config/sketchybar`
- MaCursor: `brew install --cask macursor`, then import `GoogleDot-White.cursor`
- macOS settings: `bash macos/defaults.sh`, then log out and back in
