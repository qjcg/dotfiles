hash zathura 2>/dev/null || return

# Open several pdfs in parallel w/ zathura
pdfz() {
	pdfs="$*"
	for p in "$pdfs" ; do
		{ zathura $p 2>/dev/null & }
	done
}
