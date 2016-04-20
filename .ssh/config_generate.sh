#!/bin/bash
# Concatenate modular SSH config files into ~/.ssh/config

CONFDIR="$HOME/.ssh/config.d"
CONFFILE="$HOME/.ssh/config"

# remove old file, as we regenerate from $CONFDIR sources
rm -f $CONFFILE

for fullpath in $CONFDIR/*.conf ; do
	echo -e "\n# config.d/$(basename $fullpath)\n" >> $CONFFILE
	cat $fullpath >> $CONFFILE
done
