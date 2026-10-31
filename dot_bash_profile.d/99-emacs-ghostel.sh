[[ "${INSIDE_EMACS%%,*}" == "ghostel" ]] || return

# Ghostel auto-injection supplies ghostel_cmd after sourcing .bashrc.
alias f="ghostel_cmd find-file"
alias d="ghostel_cmd dired"
