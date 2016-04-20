hash ss 2>/dev/null || return

# normal output of ss looks ugly, fix by spacing with tab characters
ss() {
	$sudocmd /usr/bin/ss "$@" | column -t
}

# print info for specific device only
ipd() {
	if [[ $# == 1 ]]; then
		ip address show dev $1
	else
		echo "Must provide device name (ex: wlp3s0)"
		return
	fi
}

alias openports="ss --numeric --processes --listening --query=tcp,udp"
