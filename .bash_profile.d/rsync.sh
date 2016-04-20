hash rsync 2>/dev/null || return

# rsync with my favourite options
alias jsync='rsync --archive --compress --itemize-changes --human-readable --partial --progress --verbose'
