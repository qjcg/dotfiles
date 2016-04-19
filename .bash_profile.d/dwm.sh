hash dwm 2>/dev/null || return

# Needed, or java programs will just display a grey window in dwm(1) (see manual)
export _JAVA_AWT_WM_NONREPARENTING=1
