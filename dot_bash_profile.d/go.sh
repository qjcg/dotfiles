hash go 2>/dev/null || return

export GOPATH=~/.local/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH
