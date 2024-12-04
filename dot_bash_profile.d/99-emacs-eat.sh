hash emacs 2>/dev/null || return

[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"

# See help for ansi-osc-directory-tracker
jg-emacs-osc-dir-track () {
  printf "\e]7;file://%s%s\e\\" "$HOSTNAME" "$PWD"
}
PROMPT_COMMAND="${PROMPT_COMMAND%;};jg-emacs-osc-dir-track"
