hash ss 2>/dev/null || return

# normal output of ss looks ugly, fix by spacing with tab characters
ss() {
	$sudocmd /usr/bin/ss "$@" | column -t
}

alias openports="ss --numeric --processes --listening --query=tcp,udp"
