hash aria2c 2>/dev/null || return

torrent_headers() {
	for torrent in $*; do
		aria2c -S $torrent | awk 'BEGIN { RS="Files:" }; NR == 1'
	done
}

torrent_name() {
	aria2c -S $* | grep ^Name: | cut -c 7-
}

torrent_files() {
	while {
		read name
		read size
	}; do
		printf "%9s  %s\n" "${size/ */}" "${name:2}"
	done < <(aria2c -S $* | grep '|' | awk -F'|' 'NR > 1 {print $2}')
}
