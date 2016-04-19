hash git 2>/dev/null || return

alias gits='find -name .git -type d | sort'

gfbs() {
	git filter-branch --subdirectory-filter "$1" -- --all
}
