# Set Console Font
cf() {
	case "$1" in
	xs) font=ter-u16n ;;
	s) font=ter-u22n ;;
	m) font=ter-u24n ;;
	l) font=ter-u32n ;;
	*) echo "Usage: cf [xs|s|m|l]"; return 1 ;;
	esac

	setfont $font
}
