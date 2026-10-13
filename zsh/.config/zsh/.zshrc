# Powerful but minimal zsh configuration
# Author: Radley E. Sidwell-Lewis
# GitHub: https://www.github.com/radleylewis/zsh
# Fix WSL Path Pollution (Removes slow Windows system paths from Zsh)
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  # Filter out heavy Windows system paths, but keep essential ones like VS Code (Code)
  PATH=$(echo "$PATH" | tr ':' '\n' | grep -v -E '/mnt/c/Windows|/mnt/c/Program Files|/mnt/c/Users/.*/AppData' | tr '\n' ':' | sed 's/:$//')
fi
# =========================================================
# Environment Paths & Fallbacks
# =========================================================
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# =========================================================
# History
# =========================================================

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# =========================================================
# Smart directory navigation & lf
# =========================================================

# Check if file exists before running cat to avoid error banner
if [[ -f ~/.config/lf/icons ]]; then
  LF_ICONS=$(cat ~/.config/lf/icons | tr '\n' ':')
  export LF_ICONS
fi

# Initialize zoxide
eval "$(zoxide init zsh)"

# =========================================================
# Completion
# =========================================================

# Load completion system
## autoload -Uz compinit

# Ensure cache directory exists so compinit doesn't fail
## mkdir -p "$XDG_CACHE_HOME/zsh"
## compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Enable interactive completion menu selection
## zstyle ':completion:*' menu select

# Make completion case-insensitive
## zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # lowercase input matches upper and lower

# =========================================================
# Completion (Optimized Cache)
# =========================================================
autoload -Uz compinit

# Ensure cache directory exists
mkdir -p "$XDG_CACHE_HOME/zsh"
local dump_file="$XDG_CACHE_HOME/zsh/zcompdump"

# Check if the cache file is older than 24 hours (86400 seconds)
# If it's fresh, use the -C flag to skip slow security audits
if [[ -n "$dump_file(#qN.m-1)" ]]; then
  compinit -C -d "$dump_file"
else
  compinit -d "$dump_file"
  # Compile it in the background for faster loading next time
  zcompile "$dump_file"
fi

unset dump_file

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'




# =========================================================
# Fuzzy finder
# =========================================================

# macOS / Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# macOS / Homebrew (Intel)
if [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# Arch
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# Ubuntu
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# =========================================================
# Modular Config Files
# =========================================================
# 1. Load completions & theme first so you see the prompt instantly
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/bindings.zsh"

# 2. Load plugins dead last so they run in the background
source "$ZDOTDIR/plugins.zsh"





# =========================================================
# Node / NVM (Lazy Loaded for Speed)
# =========================================================
export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
  # Create placeholder functions for node commands
  lazy_nvm() {
    unset -f nvm node npm npx
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    "$0" "$@"
  }
  
  # Catch the commands and trigger the real initialization on first use
  nvm()  { lazy_nvm "$@"; }
  node() { lazy_nvm "$@"; }
  npm()  { lazy_nvm "$@"; }
  npx()  { lazy_nvm "$@"; }
fi




