export HISTSIZE=99999
#export HISTTIMEFORMAT="%c  "

# print n most frequently used commands
cmdfreq() {
	num=${1:-10}
	history | cut -c 8- | sort | uniq -c | sort -rn | head -${num}
}
