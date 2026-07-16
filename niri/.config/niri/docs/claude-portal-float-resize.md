# Floating GTK file-chooser portal → ⅔ monitor height (dynamic)

Goal: make the GTK file-chooser portal window (`app_id =
xdg-desktop-portal-gtk`, e.g. title "All Files") open **floating** and take
**~2/3 of the vertical space**, on **either monitor** despite their different
resolutions/scales.

## Findings (what did NOT work, and why)

1. **`open-floating true` alone** — the portal already floats in this setup
   (FileChooser is routed to the GTK backend, commit `127a388`), so this rule
   is essentially a no-op for sizing. The window still opened at (near) full
   height.

2. **`default-window-height { proportion 0.33333 }`** — *ignored* for this
   window. It only sets a *default/initial* height hint; the GTK file chooser
   commits its own remembered size and overrides it. Tested live: window stayed
   `1378px` tall.

3. **`max-height <px>`** — this *does* clamp hard (tested: `max-height 460`
   forced the window to `460px`). BUT `max-height` only accepts **fixed
   pixels** — there is no proportional form. With two monitors of different
   working-area heights, a single fixed value can't be a consistent fraction on
   both (⅓ of the ultrawide ≈ 460px is ~⅗ of the laptop).

4. **GTK remembers its last size** — the file chooser stores its window size,
   so a "before" reading can show whatever it was last clamped to. Don't be
   fooled by it; it gets overridden by our action on open.

## Solution (dynamic, monitor-relative)

Niri's **`set-window-height "66%"`** action sizes relative to the **focused
monitor's working area**, so it is automatically ⅔ on whichever screen the
picker opens on — exactly the dynamic behaviour a window rule can't express.

Since window rules can't run actions, a tiny daemon watches the niri event
stream and fires the action when the portal window opens.

### Pieces

1. **`config.kdl`** — keep it floating:

   ```kdl
   window-rule {
       match app-id=r#"^xdg-desktop-portal-gtk$"#
       open-floating true
   }
   ```

2. **`portal-float-resize.py`** (this niri config dir) — listens to
   `niri msg -j event-stream`; on `WindowOpenedOrChanged` where
   `app_id == xdg-desktop-portal-gtk` and `is_focused == true`, runs
   `niri msg action set-window-height 66%`. Tracks handled window ids (cleared
   on `WindowClosed`) so repeated "changed" events don't re-fire.

3. **`~/.config/systemd/user/niri-portal-resize.service`** (source in
   `dotfiles/systemd/...`) — user service, `Restart=on-failure`, part of
   `graphical-session.target`; symlinked into `niri.service.wants/` so it
   starts with niri.

### Key event-stream facts (niri 26.04)

- `{"WindowOpenedOrChanged":{"window":{ "id", "app_id", "is_focused", ... }}}`
- `{"WindowClosed":{"id": N}}`
- The portal opens with `is_focused: true` immediately, and
  `set-window-height` acts on the **focused** window — so gating on
  `is_focused` guarantees we resize the right window.

## Tuning

- Change the fraction: edit `HEIGHT = "66%"` in `portal-float-resize.py`, then
  `systemctl --user restart niri-portal-resize.service`.
- Width is left at GTK's remembered value (only vertical was requested). To pin
  it, add `default-column-width` to the rule or a `set-window-width` call in the
  daemon.

## Verification

```bash
# trigger the portal from a terminal (no app needed):
gdbus call --session --dest org.freedesktop.portal.Desktop \
  --object-path /org/freedesktop/portal/desktop \
  --method org.freedesktop.portal.FileChooser.OpenFile "" "Test Open" "{}"
```

Live result: picker auto-sized to `931px` height on the ultrawide (≈⅔ of its
~1400px working area) with no manual command.

> claude --resume 0a2810f8-50a5-4e9d-a1d2-cb71e6015b26
