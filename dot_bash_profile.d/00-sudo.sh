hash sudo 2>/dev/null || return

[[ $UID != 0 ]] && export sudocmd=sudo
