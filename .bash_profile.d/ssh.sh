export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

ssh_clean_known_hosts() {
	# Clean stale ~/.ssh/known_host entries (for example, after teardown/setup of new cloud hosts).
	local hostname=${1:?Please specify a hostname.}
	sed -i "/^$hostname/d" ~/.ssh/known_hosts
}
