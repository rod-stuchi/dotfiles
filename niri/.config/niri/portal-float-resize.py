#!/usr/bin/env python3
"""Resize the floating GTK file-chooser portal to a share of the monitor.

Niri window rules can only set a *default* window height, which the GTK file
chooser overrides with its own remembered size. There is also no proportional
`max-height`. So instead we watch the niri event stream and, when the portal
window opens, apply `set-window-height <PERCENT>` — a proportion of the focused
monitor's working area, which adapts automatically across monitors of
different resolutions.
"""

import json
import subprocess
import sys

TARGET_APP_ID = "xdg-desktop-portal-gtk"
HEIGHT = "66%"  # ~2/3 of the monitor's working area

# Window ids we've already sized, so repeated "changed" events don't re-fire.
handled: set[int] = set()


def set_height() -> None:
    subprocess.run(
        ["niri", "msg", "action", "set-window-height", HEIGHT],
        check=False,
    )


def main() -> int:
    proc = subprocess.Popen(
        ["niri", "msg", "-j", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
    )
    assert proc.stdout is not None
    for line in proc.stdout:
        line = line.strip()
        if not line:
            continue
        try:
            ev = json.loads(line)
        except json.JSONDecodeError:
            continue

        if "WindowClosed" in ev:
            handled.discard(ev["WindowClosed"].get("id"))
            continue

        if "WindowOpenedOrChanged" not in ev:
            continue

        win = ev["WindowOpenedOrChanged"].get("window") or {}
        if win.get("app_id") != TARGET_APP_ID:
            continue

        wid = win.get("id")
        if wid in handled:
            continue
        # set-window-height acts on the focused window, so only fire once the
        # portal is actually focused (it grabs focus on map).
        if not win.get("is_focused"):
            continue

        handled.add(wid)
        set_height()

    return proc.wait()


if __name__ == "__main__":
    sys.exit(main())
