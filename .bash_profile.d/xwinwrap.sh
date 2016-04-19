[[ -d /usr/lib/xscreensaver ]] &&
complete -W "stop random favs video electricsheep $(ls --color=none /usr/lib/xscreensaver)" xww

# xwinwrap wrapper
xww() {
	[[ -x /usr/bin/xwinwrap &&
		-x /usr/bin/xscreensaver &&
		-d /usr/lib/xscreensaver
	]] || return

	xww_cmd='xwinwrap -b -fs -sp -nf -ov --'
	xscreensaver_exclude_list='antspotlight|blitspin|bumps|distort|flipscreen3d|gleidescope|greynetic|noseguy|ripples|slidescreen|slip|twang|webcollage-helper|xanalogtv|zoom'
	xscreensaver_random=$(ls --color=none /usr/lib/xscreensaver | grep -Ev $xscreensaver_exclude_list | shuf | head -1)
	xscreensaver_favs=(
	'cubicgrid'
	'piecewise'
	'polytopes'
	'providence'
	'stonerview'
	'xmatrix -small -mode hex -no-trace -no-knock-knock'
	'phosphor -scale 2 -font -*-terminus-medium-r-*-*-12-*-*-*-*-*-*-* -program fortune'
	)


	screensaver=${1:-glmatrix}
	shift
	videos=${*:-'https://www.youtube.com/watch?v=cuM2nzz2PmQ'}

	killall -q xwinwrap xscreensaver electricsheep mpv

	if [[ $screensaver =~ ^($xscreensaver_exclude_list) ]]; then
		echo $screensaver 'in exlude list... choose again!'
		return
	fi

	case $screensaver in
	stop) return ;;
	video) $xww_cmd /usr/bin/mpv --wid WID --ao=null --loop=inf $videos &>/dev/null & ;;
	# NOT WORKING... how to draw on root window?
	electricsheep) $xww_cmd /usr/bin/electricsheep -window-id WID & ;;
	favs)
		screensaver=${xscreensaver_favs[$(($RANDOM % ${#xscreensaver_favs[*]}))]}
		$xww_cmd /usr/lib/xscreensaver/$screensaver -root -window-id WID &
		;;
	random)
		screensaver=$xscreensaver_random
		$xww_cmd /usr/lib/xscreensaver/$screensaver -root -window-id WID &
		;;
	*) $xww_cmd /usr/lib/xscreensaver/$screensaver -root -window-id WID & ;;
	esac

	echo "$screensaver on root window via xwinwrap"
}
