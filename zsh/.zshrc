# Fastfetch greeting in top-level Ghostty shells.
if [[ -o interactive && -t 1 && $TERM_PROGRAM == ghostty && $SHLVL -eq 1 ]] && (( $+commands[fastfetch] )); then
  fastfetch
fi

# Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git fzf-tab zsh-autosuggestions fast-syntax-highlighting web-search)

# Autosuggestions: dim ghost text, history first then completions.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH/oh-my-zsh.sh

# Completion matching and menu styling.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab: monochrome fuzzy Tab menu with previews.
zstyle ':fzf-tab:*' fzf-flags --height=40% --border=rounded --info=inline-right --pointer='»' --marker='•' \
  --color='fg:250,fg+:255,bg:-1,bg+:236,hl:255:bold,hl+:255:bold,border:238,prompt:255,pointer:255,marker:255,info:242,header:242,spinner:250,query:255'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:(ls|eza|cat|bat|nvim|vim|less):*' fzf-preview '[[ -d $realpath ]] && eza -1 --icons --color=always $realpath || bat --color=always --style=plain --line-range=:60 $realpath 2>/dev/null'

# Accept the ghost suggestion with ctrl+space.
bindkey '^ ' autosuggest-accept

# Monochrome syntax theme.
[[ $FAST_THEME_NAME == mono ]] || fast-theme -q XDG:mono

# Prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Aliases
alias ls="eza --icons --git"
alias ll="eza -lah --icons --git"
alias la="eza -la --icons --git"
alias tree="eza --tree --git-ignore --icons"
alias cat="bat"

# Kill all background SSH tunnels
killtunnels() {
  local pids
  pids=$(pgrep -f '^ssh .*(-[A-Za-z]*[LRDN]|tunnel)')
  if [[ -z "$pids" ]]; then
    echo "No SSH tunnels running"
    return 0
  fi
  ps -o pid=,command= -p ${(f)pids}
  kill ${(f)pids} && echo "Killed"
}
