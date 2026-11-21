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

alias vms="virsh --connect qemu:///system list --all"

function _vm_ctl
	set -l action $argv[1]
	set -l name $argv[2]
	set -l targets
	switch "$name"
		case server1 vm1 RHEL10-VM1
			set targets RHEL10-VM1
		case server2 vm2 RHEL10-VM2
			set targets RHEL10-VM2
		case all servers
			set targets RHEL10-VM1 RHEL10-VM2
		case '*'
			echo "Usage: $action <server1|server2|all>"
			return 1
	end
	for vm in $targets
		virsh --connect qemu:///system $action $vm
	end
end

function start
	_vm_ctl start "$argv[1]"
end

function stop
	_vm_ctl shutdown "$argv[1]"
end

function vmip
	for vm in RHEL10-VM1 RHEL10-VM2
		echo "=== $vm ==="
		virsh --connect qemu:///system domifaddr $vm
	end
end

fish_add_path /home/mhdomar/.spicetify


# Added by Antigravity CLI installer
set -gx PATH "/home/mhdomar/.local/bin" $PATH

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
