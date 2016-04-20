hash youtube-dl 2>/dev/null || return

# YOUtube Audio
alias youa="youtube-dl --output '%(uploader_id)s/%(title)s_%(id)s.%(ext)s' --extract-audio --audio-format vorbis"
alias youv="youtube-dl --output '%(uploader_id)s/%(title)s_%(id)s.%(ext)s'"
alias youav="youtube-dl --output '%(uploader_id)s/%(title)s_%(id)s.%(ext)s' --extract-audio --audio-format vorbis --keep-video"
