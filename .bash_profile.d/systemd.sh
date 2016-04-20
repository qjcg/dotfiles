hash systemctl 2>/dev/null || return

# TODO: bash completion would make these aliases more useful
alias sc="$sudocmd systemctl"
alias scu="systemctl --user"

alias sch="$sudocmd systemctl poweroff"
alias scr="$sudocmd systemctl reboot"

complete -F _systemctl sc
complete -F _systemctl scu

# run several systemd-provided status-displaying commands
ctlfish() {
	cmds=(hostnamectl localectl loginctl networkctl timedatectl)
	for c in "${cmds[@]}"; do
		printf "%s\n" "$c"
		$c
		echo
	done
}
