prompt_getter() {
	[[ $PS_CHAR ]] || PS_CHAR=\$
	[[ $PS_NAME ]] || PS_NAME=classic
	[[ $PS_CHAR_COLOR ]] || PS_CHAR_COLOR='1;33'
	p="${prompts[$PS_NAME]/\$/$PS_CHAR}"
	p="${p/PS_CHAR_COLOR/$PS_CHAR_COLOR}"
	echo "$p"
}

prompt_setter() {
	PS1="$(prompt_getter)"
}

# print all ${prompts[@]} to stdout
prompt_print_all() {
	echo
	printf "%s: %s\n" PS_NAME $PS_NAME
	printf "%s: %s\n" PS_CHAR $PS_CHAR
	printf "%s: %s\n" PS_CHAR_COLOR $PS_CHAR_COLOR
	echo
	for name in "${!prompts[@]}"; do
		PS_NAME=$name
		p="$(prompt_getter)"

		# substitute prompting escapes for display purposes
		p="${p/\\u/$USER}"
		p="${p/\\h/$HOSTNAME}"
		p="${p/\\w/$PWD}"
		p="${p/\\W/$(basename $PWD)}"
		p="${p/\$/$PS_CHAR}"

		printf "%-8s: %b\n" "$name" "$p"
	done
	echo
}

prompt_toggle() {
	if [[ $PS_NAME != "one" ]]; then
		PS_NAME_LAST=$PS_NAME
		PS_NAME=one
	else
		[[ $PS_NAME_LAST ]] || PS_NAME_LAST=classic
		PS_NAME=$PS_NAME_LAST
	fi
	prompt_setter
}

# inspired by https://github.com/hellabyte/bash_colors
# see https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
print_256_colors() {
	# colors per row
	local ncpr=${1:-12}
	local testchar=${2:-▮}
	local col_idx=0
	local str="\033[38;05;%dm%3d%s\033[m "
	for i in {0..255}; do
		# wrap columns
		[[ $col_idx -ge $ncpr ]] && echo && col_idx=0

		printf "$str" "${i}" "${i}" "${testchar}"
		(( col_idx++ ))
	done
	echo
}

bind -x '"\C-pp": prompt_print_all'
bind -x '"\C-pt": prompt_toggle'


declare -A prompts
prompts[classic]="\u@\h \W \[\e[PS_CHAR_COLORm\]\$ \[\e[0m\]"
prompts[ucla]="\[\e[1;35m\u@\h\] \[\e[1;33m\]\W \[\e[PS_CHAR_COLORm\]\$ \[\e[0m\]"
prompts[min]="\W \e[PS_CHAR_COLORm\$\] \e[0m\]"
prompts[one]="\e[PS_CHAR_COLORm\$\] \e[0m\]"

#interesting_chars=( λ 𝓖 𝐆 )
PS_CHAR='λ '
# 1;: bold
# 0:grey 1:red 2:green 3:yellow 4:blue 5:purple 6:cyan
PS_CHAR_COLOR='38;05;079'
PS_NAME=classic

PS1="$(prompt_getter)"
PS2='> '
PS3='>> '
PS4='>>> '
