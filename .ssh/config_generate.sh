#!/bin/sh
# Concatenate modular SSH config files into ~/.ssh/config

CONFDIR="$HOME/.ssh/config.d"
CONFFILE="$HOME/.ssh/config"

rm $CONFFILE

for fullpath in $CONFDIR/*.conf ; do
	echo -e "\n# config.d/$(basename $fullpath)\n" >> $CONFFILE
	cat $fullpath >> $CONFFILE
done
