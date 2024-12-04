hash emacs 2>/dev/null || return

# Shell-side configuration
# See https://github.com/akermu/emacs-libvterm?tab=readme-ov-file#shell-side-configuration
vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# Directory tracking
# See https://github.com/akermu/emacs-libvterm?tab=readme-ov-file#how-can-i-get-the-directory-tracking-in-a-more-understandable-way
vterm_set_directory() {
    vterm_cmd update-pwd "$PWD/"
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }vterm_set_directory"

# Directory tracking and prompt tracking
# See https://github.com/akermu/emacs-libvterm?tab=readme-ov-file#directory-tracking-and-prompt-tracking
vterm_prompt_end(){
    vterm_printf "51;A$(whoami)@$HOSTNAME:$(pwd)"
}
PS1=$PS1'\[$(vterm_prompt_end)\]'

# Message passing
# See https://github.com/akermu/emacs-libvterm?tab=readme-ov-file#message-passing
vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}
