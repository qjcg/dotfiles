hash stty 2>/dev/null || return

# disable terminal flow control to allow forward-search-history with CTRL-s
stty -ixon

