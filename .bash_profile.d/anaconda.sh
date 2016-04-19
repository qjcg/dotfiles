export ANACONDA_PATH=~/anaconda/bin

# Prepend anaconda for SWC / DC workshops
# TODO: use PYTHONPATH instead of PATH?
# FIXME: PS1_PREFIX not untoggling, appearning multiple times
toggle_anaconda() {
	#local PS1_PREFIX='(anaconda)'

	if (( ANACONDA_ENABLED )); then
		export PATH=${PATH/${ANACONDA_PATH}:/}
		#export PS1="${PS1/${PS1_PREFIX} /}"
		export ANACONDA_ENABLED=0
	else
		export PATH=${ANACONDA_PATH}:$PATH
		#export PS1="${PS1_PREFIX} ${PS1}"
		export ANACONDA_ENABLED=1
	fi
}

# enable by default
#toggle_anaconda
