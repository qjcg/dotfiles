idempotent_add_to_path prepend ~/.cargo/bin

hash cargo 2>/dev/null || return

eval "$(rustup completions bash cargo)"
eval "$(rustup completions bash rustup)"
