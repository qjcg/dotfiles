idempotent_add_to_path prepend ~/.local/bin

hash node 2>/dev/null || return
hash npm 2>/dev/null || return

# See https://yourlabs.org/posts/2020-02-05-npm-install-g-home-local/
export NODE_PATH=$HOME/.local/lib/node_modules:$NODE_PATH
export npm_config_prefix=$HOME/.local

eval "$(npm completion)"
