#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///
"""Generic niri property toggler.

Usage: toggle.py <property>

Reads the [<property>] table from toggles.toml (next to this script), renders
its KDL template in the ON and OFF states, then writes whichever is the
opposite of what is currently in the output file (recreating it from the ON
state if it does not exist) and reloads niri.
"""

import os
import sys
import tomllib
import subprocess
from string import Template

SCRIPTDIR = os.path.dirname(os.path.realpath(__file__))
CONFIG = os.path.join(SCRIPTDIR, "toggles.toml")


def render(spec: dict, state: str) -> str:
    """Render a property's template with every slot set to `state` (on/off)."""
    slots = spec.get("slots", {})
    mapping = {name: slot[state] for name, slot in slots.items()}
    text = Template(spec["template"]).substitute(mapping)
    # Normalize: strip trailing whitespace and drop blank lines so an empty
    # `off` slot leaves no dangling line and state comparison stays stable.
    lines = [line.rstrip() for line in text.splitlines()]
    lines = [line for line in lines if line.strip()]
    return "\n".join(lines) + "\n"


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit("usage: toggle.py <property>")
    name = sys.argv[1]

    with open(CONFIG, "rb") as f:
        data = tomllib.load(f)

    if name not in data:
        known = ", ".join(sorted(data)) or "(none)"
        sys.exit(f"unknown property: {name!r} (known: {known})")

    spec = data[name]
    output = os.path.join(SCRIPTDIR, spec["output"])

    on_text = render(spec, "on")
    off_text = render(spec, "off")

    current = ""
    if os.path.exists(output):
        with open(output) as f:
            current = f.read()

    # Currently ON -> turn OFF; otherwise (incl. missing file) -> turn ON.
    new_text = off_text if current.strip() == on_text.strip() else on_text
    state = "on" if new_text == on_text else "off"

    with open(output, "w") as f:
        f.write(new_text)

    subprocess.run(["niri", "msg", "action", "load-config-file"])

    # Low-priority toast; keyed per-property so repeated toggles replace the
    # same notification instead of stacking.
    subprocess.run([
        "notify-send",
        "-u", "low",
        "-t", "8000",
        "-a", "niri",
        "-h", f"string:x-canonical-private-synchronous:niri-toggle-{name}",
        name,
        state,
    ])


if __name__ == "__main__":
    main()
