# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for i in ~/.bash_profile.d/* ; do
	[[ -r $i && $i =~ .sh$ ]] && source $i
done

set -o vi

export BROWSER=firefox
export EDITOR=vim
export VISUAL=vim
