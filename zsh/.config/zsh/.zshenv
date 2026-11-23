# ~/.config/zsh/.zshenv (sourced by ~/.zshenv)

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Default editor (keep Neovim for fif and zsh-vi-mode Esc->v)
if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
  export VISUAL="nvim"
else
  export EDITOR="nano"
  export VISUAL="nano"
fi

# Man pager (MANROFFOPT="-c" prevents garbled ANSI codes on CachyOS groff)
if command -v bat >/dev/null 2>&1; then
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif command -v batcat >/dev/null 2>&1; then
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
fi

# GPG TTY (uses Zsh built-in $TTY so non-interactive shells never print "not a tty")
if [[ -n "${TTY:-}" ]]; then
  export GPG_TTY="$TTY"
fi

# Starship config is owned by ~/.config/zsh/prompt.zsh (prompt-switch [old|default])

# Deduplicated PATH (persists across the session, including ~/.zshrc drop-ins)
typeset -U path PATH
for _dir in "$HOME/.spicetify" "$HOME/.cargo/bin" "$HOME/.local/bin"; do
  if [[ -d "$_dir" ]]; then
    path=("$_dir" $path)
  fi
done
unset _dir
export PATH
