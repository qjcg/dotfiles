hash gem 2>/dev/null || return

gem env user_gemhome &>/dev/null && {
    export GEM_HOME="$(gem env user_gemhome)"
    idempotent_add_to_path append "$GEM_HOME/bin"
}
