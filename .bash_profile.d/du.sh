# show disk usage for hidden files >1M
duh() {
	du -t 1M -hs .[!.]* | sort -h
}

# print out list of dirs sorted by disk usage
heavies() {
	[ $# -eq 0 ] && dirs=( * ) || dirs=("$*")
	$sudocmd du -hsc "${dirs[@]}" | sort -h
}

