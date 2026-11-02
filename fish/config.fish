source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# ─── Aliases & Productivity ───
alias lg="lazygit"
alias lzd="lazydocker"
alias hl="rg --passthru"
alias kssh="kitty +kitten ssh"

# ─── Instant Workspace Jumps ───
alias intern="cd '/mnt/data/Main_/INTERN LI'"
alias aegis="cd '/mnt/data/Projects/aegis-2b'"
alias blog="cd '/mnt/data/Mhdomer_logs/mhdomer.github.io'"
alias dotfiles="cd ~/dotfiles/niri"
alias data="cd /mnt/data"

# ─── Yazi Terminal File Manager ───
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
alias yazi="y"

fish_add_path /home/mhdomar/.spicetify
