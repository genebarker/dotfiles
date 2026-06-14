# Karabiner Implementation Notes

For the Warp / Super / Ghost layer design, see the zk note `karabiner.md`
([[karabiner-warp]], [[karabiner-super]], [[karabiner-ghost]]). This file
covers implementation details that don't belong in that design note.

## Web Apps via Warp Keys

Warp-key "jump to site" bindings (Warp-G, Warp-K, Warp-9, Warp-Y, Warp-M,
etc.) sort each site into one of two patterns. Firefox + Tridactyl remains
the general-purpose browser and is not part of this scheme.

### The sorting rule

Does the site have its own dense keyboard-shortcut vocabulary that would
fight the Vimari Safari extension?

- **Yes** -> Safari Web App ("Add to Dock"), Vimari disabled for that app's
  context, launched via `open -a '<Site>.app'`.
  - `Gmail.app` (Warp-M) -- j/k, c, g-i etc. would collide with Vimari.

- **No** (link-heavy, Vimari's hint-mode helps more than it hurts) -> stays
  in regular Safari with Vimari on, raised via
  `open-rsvd-safari-window.sh <host>`.
  - GitHub (Warp-G), Google Calendar (Warp-K), Google Voice (Warp-9),
    YouTube (Warp-Y).

### Reserved-window scripts

- `open-rsvd-safari-window.sh <host>` -- finds the Safari window whose
  first tab matches `<host>` and raises it, or opens a new one if none
  found.
- `open-non-rsvd-safari-window.sh` -- raises a Safari window that is *not*
  one of the reserved hosts. Its `reservedHosts` list should be kept in
  sync with the hosts driven through `open-rsvd-safari-window.sh`.

### Why Safari for this, not Firefox

Safari is AppleScript-scriptable, which is what makes these find-or-raise
scripts possible. Firefox has no equivalent, so it stays dedicated to
open-ended browsing.
