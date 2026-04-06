hash direnv 2>/dev/null || return

eval "$(direnv hook bash)"
