hash cargo 2>/dev/null || return

idempotent_add_to_path prepend ~/.cargo/bin

eval "$(rustup completions bash cargo)"
eval "$(rustup completions bash rustup)"
