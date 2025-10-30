idempotent_add_to_path() {
    local action="${1}"  # Must be either "prepend" or "append".
    local dir="${2%/}"   # Remove trailing slash if present.

    test -n "$dir" || return 1

    case ":$PATH:" in
	*:"$dir":*) return 0 ;;
	*)
	    case "$action" in
		append) export PATH="$PATH:$dir" ;;
		prepend) export PATH="$dir:$PATH" ;;
		*) echo >&2 'action must be "prepend" or "append"'
		   return 1
		   ;;
	    esac
    esac
}
