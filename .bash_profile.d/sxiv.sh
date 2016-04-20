hash sxiv 2>/dev/null || return

_find_images() {
	find "$@" -type f -regextype posix-extended -iregex '.*\.(jpg|jpeg|gif|png|bmp)$'
}

_find_gifs() {
	find "$@" -type f -iname '*.gif'
}

# Wrapper around sxiv for viewing image files
imgs() {
	# set "modes" based on command-line flags
	while getopts :hgrs opt; do
		case $opt in
		h) >&2 echo "Usage: imgs [-ghrs] [IMG_DIR]..." ; unset OPTIND; return 1 ;;
		g) local m_gif=1 ;;
		r) local m_random=1 ;;
		s) local m_slideshow=1 ;;
		esac
	done
	# enable re-invocation of getopts later
	unset OPTIND

	# _dirs should include only non-option arguments, $PWD is default
	local non_opt_args=${@/-*/}
	local _dirs=${non_opt_args:-.}

	if (( m_random )) && (( m_slideshow )); then
		_find_images $_dirs | shuf | sxiv -bfaros f -S 1 -
	elif (( m_random )) && (( m_gif )); then
		_find_gifs $_dirs | shuf | sxiv -artos f -
	elif (( m_gif )); then
		_find_gifs $_dirs | sxiv -artos f -
	elif (( m_slideshow )); then
		_find_images $_dirs | shuf | sxiv -bfaros f -S 1 -
	elif (( m_random )); then
		_find_images $_dirs | shuf | sxiv -artos f -
	else
		_find_images $_dirs | sort | sxiv -artos f -
	fi
}
