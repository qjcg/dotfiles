hash ffmpeg 2>/dev/null || return

# Capture video and audio using ffmpeg(1).

# DOCS
# 
# Video Encoding
# - https://ffmpeg.org/ffmpeg-all.html#toc-video4linux2_002c-v4l2
# - https://trac.ffmpeg.org/wiki/Capture/Webcam#Linux
# - https://trac.ffmpeg.org/wiki/Encode/VP8
# - https://trac.ffmpeg.org/wiki/Encode/VP9
# - https://trac.ffmpeg.org/wiki/Encode/H.264
#
# Video Scaling
# - https://ffmpeg.org/ffmpeg-filters.html#scale
# - https://ffmpeg.org/ffmpeg-filters.html#toc-Examples-58
# - https://ffmpeg.org/ffmpeg-utils.html#video-size-syntax
# - https://trac.ffmpeg.org/wiki/FilteringGuide
#
# Audio Encoding
# - https://www.ffmpeg.org/ffmpeg-codecs.html#toc-libvorbis
# - https://www.ffmpeg.org/ffmpeg-codecs.html#toc-libopus-1
# - http://trac.ffmpeg.org/wiki/TheoraVorbisEncodingGuide
#
# Screen Capture
# - https://ffmpeg.org/ffmpeg-all.html#toc-X11-grabbing
# - https://ffmpeg.org/ffmpeg-all.html#toc-x11grab
# - https://trac.ffmpeg.org/wiki/Capture/Desktop#Linux


# print timestamp in preferred format
_ts() {
	date +'%Y-%m-%d_%H-%M-%S'
}

screencast() {
	audio_opts=(-an)
	# can tweak -crf higher to reduce filesize (& quality)
	video_opts=(-f x11grab -s 1366x768 -i :0 -crf 23)

	ffmpeg ${audio_opts[@]} ${video_opts[@]} ./scast_$(_ts).mkv
}

webcam() {
	audio_opts=(-f alsa -ac 1 -i default)
	video_opts=(-f v4l2 -i /dev/video0 -s 1280x720)

	case $1 in
	webm)
		audio_opts+=(-c:a libvorbis)
		video_opts+=(-c:v libvpx -b:v 1M)
		ext=webm
		;;
	webm-vp9)
		audio_opts+=(-c:a libopus)
		video_opts+=(-c:v libvpx-vp9 -b:v 1M)
		ext=webm
		;;
	*)
		audio_opts+=(-c:a libvorbis)
		video_opts+=(-c:v libx264)
		ext=mkv
		;;
	esac

	# Since always get an error message otherwise getting error message...
	other_opts=(-thread_queue_size 5120)

	ffmpeg ${other_opts[@]} ${audio_opts[@]} ${other_opts[@]} ${video_opts[@]} webcam_$(_ts).${ext}
}
