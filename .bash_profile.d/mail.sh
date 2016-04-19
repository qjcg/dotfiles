# send an SMS message to a bell phone
sms_bell() {
	local num="$1"; shift
	local msg="$*"
	mail $num@txt.bell.ca <<< $msg
}

