hash adb 2>/dev/null || return

# Enable globbing with 'adb pull', allowing
# downloading of multiple files at once.
# See http://stackoverflow.com/a/11250068
adb_glob() {
	adb shell ls "$*" | tr '\r' ' ' | xargs -n1 adb pull
}
