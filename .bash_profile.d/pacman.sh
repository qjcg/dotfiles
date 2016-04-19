alias pactree="pactree -c"
alias pain="$sudocmd pacman -S"
alias pare="$sudocmd pacman -R"
alias pase="pacman -Ss"
alias paup="$sudocmd pacman -Syu"

# check if expac is installed, if not return false
expac_installed() {
	[[ -x /usr/bin/expac ]] || { echo 'This function depends on expac (pacman -S expac)' && return 1 ; }
}
package_query_installed() {
	[[ -x /usr/bin/package-query ]] || { echo 'This function depends on package-query: https://aur.archlinux.org/packages/package-query' && return 1 ; }
}

### PAW: PAcman Wrapper

paw() {
	case $1 in
	-c) shift; paw_changes "$@" ;;
	-d) shift; paw_desc "$@" ;;
	-h) shift; paw_homepage "$@" ;;
	-i) shift; paw_info "$@" ;;
	-l) shift; paw_list "$@" ;;
	-o) shift; paw_owns "$@" ;;
	-u) shift; paw_upgraded "$@" ;;
	-w) shift; paw_which_repo "$@" ;;
	-s) paw_stats ;;
	*|--help) printf "PAcman Wrapper\npaw [-cdhilouw PKGNAME(S)] [-s]\n" ;;
	esac
}

# which repo does package X come from?
paw_which_repo() {
	package_query_installed || return
	package-query -Sf '%r' "$@" || package-query -Af '%r' "$@"
}

# open package page(s) in browser
paw_homepage() {
	expac_installed || return
	for p in "$@"; do
		$BROWSER $(expac %u $p) &>/dev/null &
	done
}

# list contents of an installed package
paw_list() {
	pacman -Ql "$@" | less -iS
}

# print PAcman Package Info
# search online if package not found locally
paw_info() {
	pacman -Qi "$1" 2>/dev/null || pacman -Si "$1"
}

# Print package(s) that own files given as input
paw_owns() {
	files="$*"
	for f in $files ; do
		pacman -Qo $f
	done
}


# PAcman Upgraded Today
# show pacman packages upgraded today (or on specified date)
paw_upgraded() {
	[[ $1 ]] && date=$1 || date=$(date +%Y-%m-%d)
		
	awk '
	/'$date'.*upgraded/ {
		split($0, u, "upgraded ")
		printf("Upgraded: %s\n", u[2])
	}
	/'$date'.*installed/ {
		split($0, i, "installed ")
		printf("Installed: %s\n", i[2])
	}
	/'$date'.*removed/ {
		split($0, r, "removed ")
		printf("Removed: %s\n", r[2])
	}
	' /var/log/pacman.log
}

# PAckage CHangelog
# For future development, see https://wiki.archlinux.org/index.php/AurJson
# And look at:
#	curl -s 'https://aur.archlinux.org/rpc.php?type=search&arg=openerp' | jshon -e results
paw_changes() {
	expac_installed || return

	for pkgname in "$@"; do
		[[ -d /var/abs/community/"$pkgname" ]] && repo=community || repo=packages

		local baseurl="http://projects.archlinux.org/svntogit/${repo}.git/diff/?h=packages"
		# ss=1 : side-by-side diff
		$BROWSER "$baseurl/$pkgname&ss=1" &>/dev/null &

		local pkgurl=$(expac %u $pkgname)
		$BROWSER "$pkgurl" &>/dev/null &
	done
}

# print names and descriptions for all installed packages, one per line
paw_desc() {
	expac_installed || return
	printf "%-30s %20s %11s %-s  %-s\n" 'NAME' 'VERSION' 'SIZE' 'BUILD DATE' 'DESCRIPTION'
	local desc_fmt='%-30n %20v %11m %b  %d'
	[[ "$@" ]] && expac -t '%Y-%m-%d' -H M "$desc_fmt" "$@" || expac -t '%Y-%m-%d' -H M "$desc_fmt"
}

# print pacman statistics
paw_stats() {
	expac_installed || return

	local explicit=$(pacman -Qe | wc -l)
	local deps=$(pacman -Qd | wc -l)
	local native=$(pacman -Qn | wc -l)
	local foreign=$(pacman -Qm | wc -l)
	local unrequired=$(pacman -Qt | wc -l)
	local total=$(pacman -Q | wc -l)

	local installed_bytes=$(expac %m | awk '{ pkgs_disk_usage += $1 }; END {print pkgs_disk_usage}')
	printf "Explicit: %d Deps: %d Native: %d Foreign: %d Unrequired: %d  TOTAL: %d\n" $explicit $deps $native $foreign $unrequired $total
	# 1GB = bytes / 1000 ** 3
	# 1GiB = bytes / 1024 ** 3
	printf "Disk usage of installed packages: %d G\n" $(( $installed_bytes / 1000 ** 3 ))
}
