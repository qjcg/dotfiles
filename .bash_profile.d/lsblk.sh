hash lsblk 2>/dev/null || return

alias lsblk="lsblk -o NAME,FSTYPE,MOUNTPOINT,SIZE,LABEL,UUID"
