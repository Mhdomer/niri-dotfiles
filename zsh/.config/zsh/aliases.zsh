# Better ls
alias ls='eza --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias hl='rg --passthru'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


lf() { # zsh follow lf navigation
    tmp=$(mktemp)
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir=$(cat "$tmp")
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# =========================================================
# Editor
# =========================================================

alias vim='nvim'

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# =========================================================
# Video
# =========================================================

alias stream='mpv av://v4l2:/dev/video4 --fullscreen --demuxer-lavf-o=input_format=mjpeg,framerate=30 --profile=low-latency --untimed'

# =========================================================
# Yazi File Manager & Productivity
# =========================================================
alias lg='lazygit'
alias lzd='lazydocker'
alias zj='zellij'

# Instant Workspace Jumps
alias intern="cd '/mnt/data/Main_/INTERN LI'"
alias aegis="cd '/mnt/data/Projects/aegis-2b'"
alias blog="cd '/mnt/data/Mhdomer_logs/mhdomer.github.io'"
alias dotfiles="cd ~/dotfiles/niri"
alias data="cd /mnt/data"

# Yazi with smart-cd
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias yazi="y"

# =========================================================
# Hardware & Thermals
# =========================================================
alias quiet="powerprofilesctl set power-saver && echo '🤫 Switched to Quiet (Cool surfaces)'"
alias balanced="powerprofilesctl set balanced && echo '⚖️ Switched to Balanced'"
alias perf="powerprofilesctl set performance && echo '🚀 Switched to Performance (Full Boost)'"
alias temps="watch -n 1 'sensors 2>/dev/null | grep -E \"(Tctl|edge|temp1)\"; nvidia-smi --query-gpu=temperature.gpu,power.draw --format=csv,noheader 2>/dev/null'"

# =========================================================
# Modern Kitty Tools
# =========================================================
alias icat="kitty +kitten icat"
alias kdiff="kitty +kitten diff"
alias kssh="kitty +kitten ssh"

# =========================================================
# Productive Workflow Helpers
# =========================================================
# Create directory and enter it immediately
mkcd() { mkdir -p "$1" && cd "$1"; }

# Re-run previous command with sudo
alias please='sudo $(fc -ln -1)'

# Universal archive extractor
ex() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.7z)        7z x "$1"        ;;
      *.tar.xz)    tar xf "$1"      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Interactive live ripgrep search with bat preview and nvim jump
fif() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'right,60%,border-left,+{2}+3/3,~3' \
        --bind "enter:become(${EDITOR:-nvim} {1} +{2})"
}

slay() {
  local found=0 pid cpu command
  while read -r pid cpu command; do
    echo "Terminating PID $pid ($command) using $cpu% CPU"
    kill -9 "$pid"
    found=1
  done < <(top -b -n1 | awk 'NR>7 {if($9 > 90) print $1, $9, $12}')
  if (( found == 0 )); then
    echo "No runaway processes detected (all processes under 90% CPU)."
  fi
}

zombies() {
  local ppid_list
  ppid_list=$(ps -A -ostat,ppid | awk '$1 ~ /[zZ]/ {print $2}' | sort -u | tr '\n' ',' | sed 's/,$//')
  if [[ -n "$ppid_list" ]]; then
    echo "Detected zombie processes! Parent processes responsible:"
    ps -f -p "$ppid_list"
  else
    echo "No zombie (defunct) processes found on the system."
  fi
}

pkgdiff() {
  local file="$1"
  if [[ -z "$file" || ! -f "$file" ]]; then
    echo "Usage: pkgdiff <path-to-file>"
    return 1
  fi

  local pkg cache rel pkg_tmp
  pkg=$(pacman -Qo "$file" 2>/dev/null | awk '{print $5}')
  if [[ -z "$pkg" ]]; then
    echo "Error: No owning package found for $file" >&2
    return 1
  fi

  sudo pacman -Sw --noconfirm "$pkg" >/dev/null || return 1
  cache=$(command ls -t /var/cache/pacman/pkg/${pkg}-*.pkg.tar.zst 2>/dev/null | head -n 1)
  if [[ -z "$cache" ]]; then
    echo "Error: Package archive for $pkg not found in cache" >&2
    return 1
  fi

  rel="${file#/}"
  echo "Comparing $file with $pkg ($cache)"
  pkg_tmp=$(mktemp "/tmp/original.XXX.$(basename "$file")")
  if ! bsdtar -xOf "$cache" "$rel" >"$pkg_tmp" 2>/dev/null; then
    echo "Error: File $rel not found inside package archive" >&2
    rm -f "$pkg_tmp"
    return 1
  fi

  if command -v nvim >/dev/null 2>&1; then
    SUDO_EDITOR="nvim -d \"$pkg_tmp\"" sudoedit "$file"
  else
    diff --color=always -u "$pkg_tmp" "$file" | less -R
  fi
  rm -f "$pkg_tmp"
}

dotenv() {
  local env_file="${1:-.env}"
  if [[ ! -f "$env_file" ]]; then
    echo "Error: $env_file not found" >&2
    return 1
  fi

  local count=0 line trimmed var_name var_val
  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
    [[ -z "$trimmed" || "$trimmed" == \#* || "$trimmed" != *=* ]] && continue
    var_name="${trimmed%%=*}"
    var_val="${trimmed#*=}"
    var_name="${var_name#"${var_name%%[![:space:]]*}"}"
    var_name="${var_name%"${var_name##*[![:space:]]}"}"
    var_val="${var_val#"${var_val%%[![:space:]]*}"}"
    var_val="${var_val%"${var_val##*[![:space:]]}"}"
    if [[ ( "$var_val" == \"*\" && "$var_val" == *\" ) || ( "$var_val" == \'*\' && "$var_val" == *\' ) ]]; then
      var_val="${var_val:1:-1}"
    fi
    export "${var_name}=${var_val}"
    ((count++))
  done < "$env_file"
  echo "Loaded $count environment variables from $env_file"
}

fast() {
  if (( $# == 0 )); then
    echo "Usage: fast <command> [args...]"
    return 1
  fi
  powerprofilesctl launch --profile performance "$@"
}

alias vms='virsh --connect qemu:///system list --all'

_vm_ctl() {
  local action="$1" name="$2"
  local -a targets
  case "$name" in
    server1|vm1|RHEL10-VM1)  targets=(RHEL10-VM1) ;;
    server2|vm2|RHEL10-VM2)  targets=(RHEL10-VM2) ;;
    play|server3|vm3|RHEL10-Play) targets=(RHEL10-Play) ;;
    all|servers)             targets=(RHEL10-VM1 RHEL10-VM2) ;;
    *)
      echo "Usage: ${action} <server1|server2|play|all>"
      return 1
      ;;
  esac
  local vm
  for vm in "${targets[@]}"; do
    virsh --connect qemu:///system "$action" "$vm"
  done
}

start() { _vm_ctl start "${1:-}"; }
stop()  { _vm_ctl shutdown "${1:-}"; }

vmip() {
  local vm
  for vm in RHEL10-VM1 RHEL10-VM2 RHEL10-Play; do
    echo "=== $vm ==="
    virsh --connect qemu:///system domifaddr "$vm"
  done
}
