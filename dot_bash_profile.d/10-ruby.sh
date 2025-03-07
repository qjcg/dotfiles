hash gem 2>/dev/null || return

gem env user_gemhome &>/dev/null && {
    export GEM_HOME="$(gem env user_gemhome)"
    export PATH="$PATH:$GEM_HOME/bin"
}
