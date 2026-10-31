# Emacs status-bar research

Research date: 2026-10-30. Scope: documentation and source review, plus read-only inspection of this configuration. No implementation, package installation, configuration changes, or package performance benchmarks.

## Executive summary

Most Emacs “status bars” are compositions built on the native **mode line**, not independent widgets. Their main differences are placement, the segment API, update strategy, width handling, and how much integration and visual styling they own.

The most useful references for a custom implementation are:

- **Native Emacs** for the rendering substrate and compatibility conventions.
- **mood-line** for a small, modular, text-oriented layout and cached integration state.
- **doom-modeline** for rich integrations, mode-specific layouts, and active/inactive behavior.
- **Spaceline** for explicit segment priorities when space runs out.
- **nano-modeline** for contextual layouts and the option of a top-of-window status line.
- **mini-modeline** if a single status area is more important than independent status in each window; this placement carries substantially more minibuffer coordination.

Recommendation, not a decision: start with native Emacs facilities and borrow the small-segment approach from mood-line, contextual presentation from Nano, and explicit overflow priorities from Spaceline. Adopt a larger package only if its integrations or visual language are requirements.

## 1. What “status bar” can mean in Emacs

| Surface | Scope | Typical use | Important distinction |
| --- | --- | --- | --- |
| Mode line | One per ordinary window | Buffer identity, edit state, mode, position, diagnostics | Its format is normally buffer-local, but rendering is window-contextual. |
| Header line | One per ordinary window, at the top | Context, breadcrumbs, or a relocated status line | Uses the same construct language but is a separate surface. |
| Tab line | One per ordinary window, at the top | Buffer tabs | Not the frame-wide tab bar. |
| Tab bar | One per frame, at the top | Window-configuration tabs; customizable extra items | Controlled by `tab-bar-format`, not by replacing `mode-line-format`. |
| Minibuffer/echo area | Shared command/message area of a frame | A consolidated status display when idle | Must yield to command input and coordinate with messages. |

GNU documents mode/header/tab lines as per-window surfaces. `mode-line-format`, `header-line-format`, and `tab-line-format` are normally buffer-local; window parameters can override them. Consequently, two windows showing the same buffer can share a format but need different position and active-state rendering. [G1][G2][G3]

The tab bar is explicitly frame-wide and has its own customizable format. A “global bottom bar” is therefore a different architectural problem from the conventional mode line; a minibuffer-based package is one approach, rather than a special global mode-line variable. [G11][M1]

## 2. The native rendering model

### A small declarative language

`mode-line-format` is a template composed of strings, symbols, lists, conditionals, width specifications, `:eval` expressions, and `:propertize` forms. `%` constructs provide native substitutions such as buffer identity and position. Symbols normally resolve to their values; a symbol whose value is a string displays that string literally rather than reinterpreting its `%` sequences. [G4]

This is already enough to implement custom segments without a framework. Faces control color and typography; `help-echo` supplies tooltips; keymaps make segments mouse-sensitive. These keymaps are for mouse interaction, not keyboard focus inside the line. [G5]

### Updates happen through redisplay

Emacs does not continuously rebuild every line. Changes such as scrolling, editing, buffer switches, or window reconfiguration trigger updates when needed. Code that changes externally computed status should call `force-mode-line-update`; passing a non-nil argument requests an update of all mode/header lines at the next redisplay. It does not itself mean an immediate synchronous redraw. [G2]

The useful separation is:

**event or timer → update state/cache → request redisplay → cheap segment rendering**

GNU explicitly warns against loading files or calling functions that themselves evaluate the mode line inside `:eval`, because recursion can result. Extending that into a design rule: subprocesses, network requests, repeated project discovery, and expensive scans should stay outside the render path. This is a recommendation, not a claim that every reviewed package follows it perfectly. [G4]

### Modern Emacs reduces the need for helper packages

Emacs provides `mode-line-format-right-align` and `mode-line-right-align-edge` for right alignment. The alignment marker must appear as the symbol in `mode-line-format`; it is not a substitute for a general header-line alignment API. Its implementation measures following content and uses a stretch-space display property. The option is marked as introduced in Emacs 30.1. [G6][G7]

`mode-line-window-selected-p` is intended for mode-line `:eval` forms and handles selected-window context, including minibuffer activity. Modern standard faces include `mode-line-active` and `mode-line-inactive`. [G2][G7]

### Compatibility matters

The manual recommends retaining standard variables instead of reconstructing all their contents independently. Relevant extension points include `mode-line-buffer-identification`, `mode-line-process`, `mode-line-modes`, and `mode-line-misc-info`. The latter normally includes `global-mode-string`, which is where `display-time` contributes its clock. [G3][G6]

There is also a security-related subtlety: properties and `:eval`/`:propertize` forms reached through an unmarked variable can be ignored. A code-owned segment variable may need the `risky-local-variable` property; this should not be confused with allowing arbitrary executable file-local configuration. [G4][G5]

## 3. Package comparison

| Approach | How it works | Customization model | Main lesson or trade-off |
| --- | --- | --- | --- |
| **Native mode line** | Emacs interprets a mode-line construct during redisplay. | Standard variables, ordinary Lisp, faces, `:eval`, mouse keymaps. | Minimal external dependencies and maximum control; integration and overflow policy are yours. [G2–G6] |
| **doom-modeline** | Registers named segments and named left/right layouts, with compiled segment functions, custom width calculation, and many integration caches. | `doom-modeline-def-segment`, `doom-modeline-def-modeline`, options, faces, buffer-specific layouts. | Rich integration reference, but a larger dependency and compatibility surface. [D1–D3] |
| **mood-line** | Evaluates configurable left/right segment lists; optional VC/checker modules update buffer-local text caches through hooks/advice. | `mood-line-format`, `mood-line-defformat`, glyph sets, faces, regular segment functions. | A particularly clear reference for a small text-oriented custom line. [O1–O3] |
| **smart-mode-line** | Reworks standard mode-line components, emphasizes path abbreviation and readable widths, and hooks buffer/directory changes. | Path-replacement regexps, name/mode width settings, themes, minor-mode filtering. | Useful if file identity and compatibility with the traditional line matter more than a new segment framework. [S1][S2] |
| **telephone-line** | Groups subsegments into colored “supersegments,” adding primary and secondary separators between them. | Left/right group alists, segment definitions, face maps, separator functions; mode/header target. | Strong modular visual composition, with image/face/separator geometry to manage. [T1][T2] |
| **Spaceline** | Compiles left/right segment specifications into rendering functions and uses Powerline for rendering support. | Segment DSL with `:when`, `:priority`, `:fallback`, faces and padding. | The strongest explicit example of priority-based shrinking; more DSL and dependencies. [P1][P2] |
| **nano-modeline** | Builds contextual left/right layouts, installable as a header or footer, with presets selected by major-mode hooks. | Component functions and per-mode compositions; `nano-modeline-position` defaults to the header installer. | Good inspiration for a quiet, context-sensitive UI; header ownership and font metrics need care. [N1][N2] |
| **mini-modeline** | Formats status into the idle minibuffer, optionally hides ordinary lines, and coordinates message/input state. | Mode-line-compatible left/right formats, refresh interval, echo placement, frame and padding options. | Closest to a consolidated status area, but substantially more coordination with minibuffer behavior. [M1] |

### doom-modeline: integrations separated from rendering

The core maps segment names to functions or variables, prepares a layout, formats/measures the right-hand content, and inserts a stretch-space separator. The segment file caches file identity, icons, VC state, and checker state, refreshing them through events such as file visits, saves, VC refreshes, and checker notifications. The core also has a per-frame font-height cache. [D2][D3]

Its active/inactive policy can both change faces and suppress segments. Narrow-window behavior is governed by a width threshold and individual visibility decisions, rather than Spaceline's general numeric priority model. It supplies specialized layouts for buffers such as Info, PDF, and package views. [D1–D3]

The inspected package declares `compat`, `nerd-icons`, and `shrink-path` dependencies. Icons are optional in presentation and have Unicode/text fallbacks, but disabling icons is not the same as removing the declared package dependency. The current documented icon path is Nerd Icons, not an assumption that all-the-icons is mandatory. [D1][D2]

### mood-line: a small segment interface

`mood-line-defformat` creates left/right segment sequences with conditional separators: an absent segment need not leave dangling punctuation. The main renderer evaluates those sequences and applies a stretch-space alignment property. VC and checker render functions return already prepared buffer-local strings. [O1]

Hooks/advice perform integration updates, and enabling/disabling the global mode installs/removes those handlers and saves/restores default settings. Its miscellaneous/process segments reuse the standard mode-line constructs rather than inventing a second clock/process API. [O1–O3]

Source caveat: the inspected GitHub mirror is an older implementation; the GitLab `main` source identifies itself as version 3.1.0 and has the modular format API. The `git.tty.dog` URLs found by search returned 404 during this review. The comparison uses the fetched GitLab source, not the stale GitHub mirror. This does not establish a maintenance or release-cadence ranking. [O1]

### smart-mode-line: improve the existing line

Its central idea is readable buffer identity: shorten directories, replace known roots with meaningful prefixes, and manage widths for names and minor modes. It modifies standard mode-line variables, regenerates identity on save/rename/directory changes, and includes a `display-time-hook` integration. [S1][S2]

Borrow its path-presentation ideas even if we do not adopt its package. A bare filename can be ambiguous when multiple projects contain files with the same name; a short project-relative identity is often more informative. That is a design inference, not a usability measurement.

### telephone-line and Spaceline: composition and overflow

Telephone Line separates content, colors, and separator generation. Its documentation describes separators as generated, propertized images, with character fallbacks in terminals; its target can be the mode line or header line. The configuration groups small functions by shared face. [T1][T2]

Spaceline adds a more explicit display policy: `:priority` controls which segments survive when the window shrinks, `:when` controls eligibility, and `:fallback` supplies an alternative when a segment produces no output. The fallback facility is not itself documented as a “compact version when narrow” switch. Layout compilation is separate from the evaluated renderer. [P1][P2]

For a custom bar, the reusable idea is to decide which information is essential before discussing separator shapes.

### nano-modeline: status should match the buffer

Its schematic is `[ status | name (primary) ... secondary ]`. Presets change the information for programming, text, Org, terminals, PDF, mail, and other buffers. Installation can be buffer-local or default; choosing a header is not choosing a frame-wide bar. [N1][N2]

The inspected renderer reserves space for the right side and truncates the left. Some of its calculations use string length/window columns, illustrating why an attractive design is not evidence that variable-pitch, wide-glyph, or extremely narrow layouts are automatically handled correctly. Those cases need verification in our font setup. [N2]

### mini-modeline: relocating status changes the lifecycle

The source uses a timer, an output cache, `message` advice, minibuffer setup/exit hooks, and pre/post-command hooks. It avoids rendering while the minibuffer is active or input is pending, manages echo-message duration, and can hide ordinary mode lines while retaining thin visual separators. [M1]

This is more than changing the format variable. A custom minibuffer status area would need a clear policy for prompts, echo messages, completion, frame targeting, and restoring the prior configuration.

## 4. Implications for this configuration

Read-only local findings:

- `private_dot_config/private_emacs/lisp/init/jg-appearance.el` configures Fontaine presets, Ef Themes, Spacious Padding, and Logos.
- The font setup includes Nerd Font presets and variable-pitch UI settings. Alignment must be tested with the fonts actually used, not inferred from character counts.
- Spacious Padding is enabled with `spacious-padding-subtle-mode-line`. This changes appearance/padding, not status content. Upstream currently retains that name as an obsolete alias to `spacious-padding-subtle-frame-lines`; migrating it is outside this research task. [A1][A2]
- Logos is configured to hide both the mode line and header line in focus mode. A replacement should preserve that behavior unless we explicitly decide otherwise.
- `private_dot_config/private_emacs/lisp/init/jg-core.el` enables `display-time-mode` with a fairly long date/time/timezone format. A custom line should consciously retain, shorten, relocate, or omit this information rather than accidentally drop the standard extension point. [G6]
- No third-party mode-line replacement was found in the inspected tracked Lisp or in the targeted check of `var/custom.el`.
- The installed underlying binary, `/snap/emacs/current/usr/bin/emacs`, reports **Emacs 31.1**. A `--batch -Q` capability check confirmed both `mode-line-format-right-align` and `mode-line-window-selected-p` are available. This did not load the live init or execute downloaded package code.

This means there is no immediate need to adopt a framework merely to obtain right alignment, selected-window styling, or padded presentation.

## 5. Design principles worth carrying forward

These are research-derived recommendations, not an agreed implementation spec:

1. **Choose the surface first.** Per-window bottom status, per-window top context, and a single frame status area have different ownership and update requirements.
2. **Keep state acquisition separate from rendering.** Cheap native substitutions can render directly; slow integrations should update caches outside redisplay.
3. **Give state the correct scope.** Diagnostics and file identity are buffer-scoped; visible position and active styling are window-scoped; some global indicators may be frame- or session-scoped.
4. **Make overflow explicit.** Preserve essential identity and dangerous states; shorten optional details before dropping low-priority extras. Decide this order rather than letting the last text silently disappear.
5. **Use semantic faces and optional glyphs.** Keep themes/Fontaine/Spacious Padding in control where practical, with a readable text fallback rather than font icons carrying all the meaning.
6. **Preserve native extension points deliberately.** In particular, decide what to do with process information, `mode-line-misc-info`/`global-mode-string`, and major-mode-specific formats.
7. **Make lifecycle reversible.** Disabling or reloading should clean up owned hooks/timers/advice and restore the prior format, without replacing unrelated buffer-local settings.

If we later implement, important verification cases include GUI and terminal frames, multiple frames, two windows showing the same buffer at different positions, narrow splits, mixed fonts/wide glyphs, filenames containing `%`, remote files, large buffers, focus mode, and active minibuffer completion. No such implementation testing has been done here.

## 6. Decisions to make before building

- **Placement:** bottom of every window, top of every window, or one shared frame-level status area?
- **Primary job:** buffer identity, project/workspace awareness, diagnostics, editing state, or global/agent activity?
- **Density:** quiet defaults with detail on demand, or an always-visible dashboard?
- **Appearance:** text-only, a few optional icons, or colored Powerline-style blocks?
- **Inactive windows:** identity only, dimmed full status, or hidden status?
- **Context:** one universal layout, or specific layouts for code, Org, Dired, terminals, and agent buffers?

My starting preference for this setup is **a native, per-window mode line with a small segment interface**, not a large visual framework. That preference should change if the desired result is specifically a single frame-wide dashboard or a heavily integrated Doom-style line.

## Primary sources

### GNU Emacs

- [G1] [Mode Line Format](https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Format.html).
- [G2] [Mode Line Basics](https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Basics.html): update lifecycle, window context, selected-window predicate and faces.
- [G3] [Top Level of Mode Line Control](https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Top.html): buffer-local ownership and compatibility conventions.
- [G4] [Mode Line Data](https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Data.html): constructs, evaluation, width, variable security behavior.
- [G5] [Properties in the Mode Line](https://www.gnu.org/software/emacs/manual/html_node/elisp/Properties-in-Mode.html): faces, tooltips, mouse keymaps and variable properties.
- [G6] [Mode Line Variables](https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Variables.html): alignment and standard integration variables.
- [G7] [Emacs 30 `bindings.el`](https://github.com/emacs-mirror/emacs/blob/emacs-30/lisp/bindings.el): native right-alignment implementation and selected-window predicate.
- [G11] [Tab Bars](https://www.gnu.org/software/emacs/manual/html_node/emacs/Tab-Bars.html): frame scope and `tab-bar-format`.

### Packages

- [D1] [doom-modeline README and main file](https://github.com/seagle0128/doom-modeline): documented integrations, layouts, icons, options and package dependencies.
- [D2] [doom-modeline-core.el](https://github.com/seagle0128/doom-modeline/blob/master/doom-modeline-core.el): segment registration, rendering, alignment, active state and caches.
- [D3] [doom-modeline-segments.el](https://github.com/seagle0128/doom-modeline/blob/master/doom-modeline-segments.el): cached integration state and event hooks.
- [O1] [mood-line.el, GitLab main](https://gitlab.com/jessieh/mood-line/-/blob/main/mood-line.el): modular API, glyph sets, renderer, lifecycle and cached segments.
- [O2] [mood-line-segment-vc.el](https://gitlab.com/jessieh/mood-line/-/blob/main/mood-line-segment-vc.el).
- [O3] [mood-line-segment-checker.el](https://gitlab.com/jessieh/mood-line/-/blob/main/mood-line-segment-checker.el).
- [S1] [smart-mode-line README](https://github.com/Malabarba/smart-mode-line/blob/master/README.org).
- [S2] [smart-mode-line.el](https://github.com/Malabarba/smart-mode-line/blob/master/smart-mode-line.el).
- [T1] [Telephone Line configuration](https://github.com/dbordak/telephone-line/blob/master/configuration.org).
- [T2] [telephone-line.el](https://github.com/dbordak/telephone-line/blob/master/telephone-line.el).
- [P1] [Spaceline README](https://github.com/TheBB/spaceline/blob/master/README.org).
- [P2] [spaceline.el](https://github.com/TheBB/spaceline/blob/master/spaceline.el).
- [N1] [Nano Modeline README and screenshot](https://github.com/rougier/nano-modeline).
- [N2] [nano-modeline.el](https://github.com/rougier/nano-modeline/blob/master/nano-modeline.el).
- [M1] [mini-modeline.el](https://github.com/kiennq/emacs-mini-modeline/blob/master/mini-modeline.el).
- [A1] [Spacious Padding manual](https://github.com/protesilaos/spacious-padding/blob/main/README.org).
- [A2] [spacious-padding.el](https://github.com/protesilaos/spacious-padding/blob/main/spacious-padding.el).

Sources are linked to upstream branches and may change after the research date. Architectural observations are source-based; adjectives such as “fast” in package descriptions are not comparative benchmark results.
