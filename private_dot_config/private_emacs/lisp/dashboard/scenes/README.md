# Dashboard scenes

`jg-dashboard` picks a local scene on open. Press `a` to shuffle or `A` to
browse the gallery. Previews reflow into more columns as the window widens.
Use `TAB` / `S-TAB` to move between scenes, `RET` (or click the title or
artwork) to select, and `q` to return without changing the scene. Refreshes
and resizes keep the current dashboard scene. Customize
`jg-dashboard-scene-directory` to use a different directory or disable art.

Drop a `.txt` or `.ans` file here. The filename (without its extension)
is the panel title. Use printable ASCII and optional ANSI SGR colors
(including 24-bit foreground and background). Use spaces instead of tabs.
Aim for 64 columns by 18 rows so the art fits beside the widgets. Narrow
windows scale it down. Files over 256 KiB, 240 columns, or 80 rows are skipped.

- **Dream of Arcadia:** ANSI rendering of Thomas Cole's [public-domain painting](https://commons.wikimedia.org/wiki/File:Thomas_Cole_-_Dream_of_Arcadia_-_Google_Art_Project.jpg).
- **Phosphor Trefoil:** a procedural demoscene knot rendered in ANSI color.
- **Aurora over the Fjord**, **Caravan of Ember**, and **River of Fire**:
  northern lights, sunset dunes, and a volcanic lava flow.
- **Castle above the Clouds**, **The Last Lighthouse**, and **Torii at Dusk**:
  silhouettes in moonlight, fog, and sunset.
- **Pelagic Lanterns**, **The Glass Cathedral**, **The Rings of Asterion**,
  and **Violet City 2084**: deep-sea jellyfish, a stained-glass rose window,
  a ringed planet, and a synthwave skyline.

A future opt-in AI generator could save scenes in this same format and update
the dashboard asynchronously. The current picker only reads local files.
