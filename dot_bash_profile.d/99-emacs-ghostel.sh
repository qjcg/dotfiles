[[ "${INSIDE_EMACS%%,*}" == "ghostel" ]] || return

# Auto-injection runs after .bashrc, but nested/restarted Bash shells can
# inherit INSIDE_EMACS without the helper.  Load upstream integration lazily
# so normal startup keeps Ghostel's intended prompt-hook ordering.
jg_ghostel_cmd() {
    if ! declare -F ghostel_cmd >/dev/null; then
        if [[ -n "${EMACS_GHOSTEL_PATH:-}" && -r "$EMACS_GHOSTEL_PATH/etc/shell/ghostel.bash" ]]; then
            source "$EMACS_GHOSTEL_PATH/etc/shell/ghostel.bash"
        fi
        if ! declare -F ghostel_cmd >/dev/null; then
            printf 'Ghostel shell integration unavailable; check EMACS_GHOSTEL_PATH.\n' >&2
            return 127
        fi
    fi
    ghostel_cmd "$@"
}

alias f="jg_ghostel_cmd find-file"
alias d="jg_ghostel_cmd dired"
