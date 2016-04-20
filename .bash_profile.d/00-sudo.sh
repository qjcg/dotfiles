hash sudo >/dev/null || return
[[ $UID != 0 ]] && export sudocmd=sudo
