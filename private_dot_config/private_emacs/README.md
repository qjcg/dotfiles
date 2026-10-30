# Emacs terminal workflow

Ghostel terminals are managed by `lisp/jg-ghostel.el`, loaded by
`lisp/init/jg-shell.el`. No extra terminal/window-management package is needed.

## Keys

| Key | Action |
| --- | --- |
| ``C-` `` | Summon, focus, or hide the current context's terminal |
| ``C-u C-` `` | Create another terminal in the current context |
| `C-c t n` | Create another terminal in the current context |
| `C-c t b` | Choose a terminal in the current context |
| `C-c t ]` / `C-c t [` | Next / previous terminal, wrapping within the context |
| `C-c t f` | Toggle quake panel ↔ full editing area |
| `C-c t g` | Toggle a global terminal, even inside a project |
| `C-c t G` | Create another global terminal |
| `C-c t t` | Choose from all managed project and global terminals |

The top panel occupies approximately 35% of the frame height. Customize
`jg-ghostel-quake-height` to change that fraction. Full display fills the
Emacs editing area; it does not change OS fullscreen state. Shrinking or
hiding restores the editor layout. Each terminal remembers its display mode
for its lifetime: after expanding with `C-c t f`, the toggle alternates between
hidden and full-frame. Press `C-c t f` again to return to quake mode; subsequent
hide/show toggles then retain quake mode. Reopening fullscreen captures the
current editor layout, so editor changes made while hidden are preserved.

Switching or creating terminals in an already open view keeps its display mode
and remembers that mode for the selected terminal. Otherwise, a new terminal
starts in quake mode. Window layouts are independent per frame; terminal buffers
and their remembered display preferences are shared across frames. Preferences
are in-memory for the terminal session, not persisted across Emacs restarts.

Inside a managed terminal, its creation-time ownership determines the context.
Otherwise, the current `project.el` project determines it; outside projects,
the global group is used. Project terminals start at the project root; global
terminals start in `~`. Shell `cd` and buffer renaming do not change ownership.
Projects are distinguished by their full roots, including TRAMP prefixes, not
just names. The completion picker annotates each terminal with its owner and
Ghostel's process status/title, using the normal Vertico/Orderless setup.

The toggle reuses the most recently used terminal in that group. An unfocused,
already visible matching panel is focused rather than hidden. Hiding leaves
processes running; terminal exit or buffer killing closes the view and restores
the editor. While a panel is open, editor splits can still be changed normally.

The Ghostel action in the project-switch menu uses this same workflow and always
shows the selected project's terminal. Existing `ghostel-project` terminals are
adopted by identity. Plain `M-x ghostel` terminals and Ghostel compilation/exec
buffers remain outside the managed groups and are still accessible via `C-x b`.

The terminal controls work in semi-char, char, copy, Emacs, and line input modes.
Even in char mode, ``C-` `` and the `C-c` / `C-u` prefixes are reserved for Emacs.
Use `C-c C-c` for interrupt and `C-c C-q` to send a reserved key literally. On
TTY connections that cannot encode Ctrl-backtick distinctly, the named command
`M-x jg-ghostel-toggle` remains available outside char mode.

GPTel remains on `C-c SPC SPC`; its old ``C-` `` binding is removed.

## Tests

From this directory:

```sh
task test-ghostel
task test-ghostel-gui
```

`test-ghostel` loads installed Ghostel Lisp without its native module, substitutes
only shell creation, and exercises real windows, identities, and keymaps. The
multi-frame test is skipped in headless batch mode.

`test-ghostel-gui` runs the same suite plus real-shell integration tests in an
isolated Xvfb display, including multiple frames and native line-mode entry.
It requires `xvfb-run`, `xauth`, and a working installed Ghostel native module.
Neither task loads or changes the running Emacs configuration.

Override `EMACS` for a non-snap installation, and `EMACS_DIR` to select a package
directory (packages are read from `$EMACS_DIR/var/elpa`). The snap default uses
its underlying binary because the wrapper requires a display even in batch mode.
