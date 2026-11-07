# =========================================================
# Keybindings
# =========================================================

# Cursor shape per vi mode
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# Disable command mode line highlight
ZVM_VI_HIGHLIGHT_BACKGROUND=none
ZVM_VI_HIGHLIGHT_FOREGROUND=none
ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

# Smart right arrow: accepts autosuggestion if cursor is at end of buffer and suggestion exists,
# otherwise acts as a normal forward-char so you never get stuck navigating inside commands.
_smart_right_arrow() {
  if [[ -n "$POSTDISPLAY" ]] && (( CURSOR == ${#BUFFER} )); then
    zle autosuggest-accept
  else
    zle forward-char
  fi
}
zle -N _smart_right_arrow

# zsh-vi-mode resets all bindings on init, so custom bindings
# must be registered via this hook to survive.
zvm_after_init() {
  # Alias zsh-autosuggestions-accept to autosuggest-accept so legacy references never fail
  zle -N zsh-autosuggestions-accept autosuggest-accept 2>/dev/null || true

  # Ctrl+Right -> move forward one word (^[[1;5C is the terminal escape code)
  bindkey '^[[1;5C' forward-word
  zvm_bindkey viins '^[[C' _smart_right_arrow
  zvm_bindkey viins '^[OC' _smart_right_arrow
  bindkey '^[[C' _smart_right_arrow
  bindkey '^[OC' _smart_right_arrow
  # Ctrl+Left -> move backward one word (^[[1;5D is the terminal escape code)
  bindkey '^[[1;5D' backward-word

  # Ctrl+F -> fzf file picker (no hidden files)
  bindkey '^F' _fzf_file_no_hidden

  # Ctrl+\ -> toggle autosuggestions (useful for screen recordings)
  bindkey '^\' autosuggest-toggle

  # Up/Down -> history search by substring (^[[A/^[[B are up/down arrow escape codes)
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}
