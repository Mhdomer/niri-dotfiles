zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' complete-options true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}[%d]%f'
zstyle ':completion:*:warnings' format '%F{red}no matches for: %d%f'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

autoload -Uz bashcompinit && bashcompinit

if [[ -x "$HOME/.local/bin/aws_completer" ]]; then
  complete -C "$HOME/.local/bin/aws_completer" aws
elif (( $+commands[aws_completer] )); then
  complete -C "$commands[aws_completer]" aws
fi

for _cmd in agy sops age age-keygen tectonic disktree graphify vanish-cam kiro-cli; do
  (( $+commands[$_cmd] )) && compdef _gnu_generic "$_cmd"
done
unset _cmd

comp-refresh() {
  local comp_dir="${ZDOTDIR:-$HOME/.config/zsh}/completions"
  mkdir -p "$comp_dir"

  (( $+commands[kubectl] ))  && kubectl completion zsh > "$comp_dir/_kubectl"
  (( $+commands[k9s] ))      && k9s completion zsh > "$comp_dir/_k9s"
  (( $+commands[uv] ))       && uv generate-shell-completion zsh > "$comp_dir/_uv"
  (( $+commands[uvx] ))      && uvx --generate-shell-completion zsh > "$comp_dir/_uvx"
  (( $+commands[gitleaks] )) && gitleaks completion zsh > "$comp_dir/_gitleaks"
  (( $+commands[zellij] ))   && zellij setup --generate-completion zsh > "$comp_dir/_zellij"
  (( $+commands[bw] ))       && bw completion --shell zsh > "$comp_dir/_bw"
  (( $+commands[dive] ))     && dive completion zsh > "$comp_dir/_dive"
  (( $+commands[xh] ))       && xh --generate complete-zsh > "$comp_dir/_xh"
  (( $+commands[trip] ))     && trip --generate zsh > "$comp_dir/_trip"

  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"*
  autoload -Uz compinit
  compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
  zcompile "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
  echo "Refreshed Zsh completions and zcompdump."
}
