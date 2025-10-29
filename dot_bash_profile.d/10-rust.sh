hash ~/.cargo/bin/cargo 2>/dev/null || return

source ~/.cargo/env

eval "$(rustup completions bash cargo)"
eval "$(rustup completions bash rustup)"
