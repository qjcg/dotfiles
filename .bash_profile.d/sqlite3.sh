hash sqlite3 2>/dev/null || return

#sqlite3() {
#	rlwrap=/usr/bin/rlwrap
#	sqlite3=/usr/bin/sqlite3
#	
#	cmd=($sqlite3 "$@")
#	if [[ -x $rlwrap ]]; then
#		cmd=($rlwrap ${cmd[@]})
#	fi
#
#	exec "${cmd[@]}"
#}
