hash go 2>/dev/null || return

export GOPATH=~/.local/go
export GOBIN=$GOPATH/bin
export GO15VENDOREXPERIMENT=1
export GOME=$GOPATH/src/github.com/qjcg
export PATH=$PATH:$GOBIN

go-update-binaries() {
	reponames=()
	for b in $GOBIN/*; do
		[[ -x $b ]] || continue
		cmd=$(basename $b)
		repo_abspath=$(find $GOPATH/src -type d -name $cmd | head -1 | grep -v '.hg')
		repo=${repo_abspath/$GOPATH\/src\//}

		reponames+=(${repo})
	done

	for r in ${reponames[@]}; do
		go get -u $r
	done
}
