"""Send one real X11 mouse drag to the isolated Xvfb Emacs test frame."""

import ctypes
import ctypes.util
import sys
import time


def main():
    x1, y1, x2, y2 = map(int, sys.argv[1:])
    x11 = ctypes.CDLL(ctypes.util.find_library("X11"))
    xtst = ctypes.CDLL(ctypes.util.find_library("Xtst"))
    display_type = ctypes.c_void_p
    x11.XOpenDisplay.argtypes = [ctypes.c_char_p]
    x11.XOpenDisplay.restype = display_type
    x11.XFlush.argtypes = [display_type]
    x11.XCloseDisplay.argtypes = [display_type]
    xtst.XTestFakeMotionEvent.argtypes = [display_type, ctypes.c_int,
                                        ctypes.c_int, ctypes.c_int, ctypes.c_ulong]
    xtst.XTestFakeButtonEvent.argtypes = [display_type, ctypes.c_uint,
                                        ctypes.c_int, ctypes.c_ulong]
    display = x11.XOpenDisplay(None)
    if not display:
        raise RuntimeError("Xvfb display is unavailable")
    try:
        xtst.XTestFakeMotionEvent(display, -1, x1, y1, 0)
        x11.XFlush(display)
        time.sleep(0.1)
        xtst.XTestFakeButtonEvent(display, 1, 1, 0)
        x11.XFlush(display)
        time.sleep(0.1)
        xtst.XTestFakeMotionEvent(display, -1, (x1 + x2) // 2, (y1 + y2) // 2, 0)
        x11.XFlush(display)
        time.sleep(0.1)
        xtst.XTestFakeMotionEvent(display, -1, x2, y2, 0)
        x11.XFlush(display)
        time.sleep(0.1)
    finally:
        xtst.XTestFakeButtonEvent(display, 1, 0, 0)
        x11.XFlush(display)
        x11.XCloseDisplay(display)


if __name__ == "__main__":
    main()
