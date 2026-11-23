# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

FUNCNEST=100

_starship_apply() {
  local mode="${1:-old}"
  if [[ "$mode" == "default" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
  else
    export STARSHIP_CONFIG="$HOME/.config/zsh/starship.toml"
  fi
}

prompt-switch() {
  local mode="$1"
  if [[ -z "$mode" ]]; then
    if [[ "$STARSHIP_CONFIG" == "$HOME/.config/starship.toml" ]]; then
      mode="old"
    else
      mode="default"
    fi
  fi
  echo "$mode" > "$HOME/.config/zsh/.starship-mode"
  _starship_apply "$mode"
  echo "Starship prompt: $mode ($STARSHIP_CONFIG)"
}

_starship_apply "$(cat "$HOME/.config/zsh/.starship-mode" 2>/dev/null || echo old)"

eval "$(starship init zsh)"
