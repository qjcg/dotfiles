_doc_help() {
	cat <<-END
	doc <rmi|rrm|up>
	END
}

# shortcut to run then remove an image
_doc_run_remove() {
	local image=${1:?}
	local name=${2:?}
	docker run --rm -i -t --name $name --hostname $name $image
}

# remove all crufty outdated images
_doc_remove_crufty_images() {
	local old_images=$(docker images | awk '$1 ~ /<none>/ {print $3}')
	docker rmi $old_images
}

# update all images matching pattern
_doc_update_images() {
	local pattern=${1:-""}
	local images=( $(docker images | awk '$1 ~ /'$pattern'/ {printf("%s:%s\n", $1, $2)}') )

	# just echo image names if in debug mode
	local debug=${2:-""}
	local cmd='docker pull'
	[[ $debug ]] && cmd='echo docker pull'

	for i in ${images[*]}; do
		echo UPDATING $i
		$cmd $i
		echo
	done
}

doc() {
	case "$1" in
	rmi) _doc_remove_crufty_images ;;
	rrm) _doc_run_remove "${@:2}" ;;
	up) _doc_update_images "${@:2}" ;;
	-h|--help|help|*) _doc_help ;;
	esac
}
complete -W "$(docker images | awk 'NR != 1 {print $1}')" doc
