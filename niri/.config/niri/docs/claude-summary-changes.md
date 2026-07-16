# Niri startup: migrate from `.runall.sh` to systemd user services

Date: 2026-06-22

## Goal
Replace the niri `spawn-sh-at-startup "/home/rods/.runall.sh"` line with proper
systemd **user** services, so that:

`niri-session` → starts `niri.service` → activates `graphical-session.target`
→ pulls in everything under `~/.config/systemd/user/niri.service.wants/`
(mako, waybar, swayidle, qpwgraph, ssh-agent, bluetooth-battery-monitor).

This is the niri-recommended setup and matches the original mental model.

## Why it wasn't working before (two root causes)

### 1. tty1 hangs forever (shell recursion)
`.zprofile` autostart only fires on VT1 (`$XDG_VTNR -eq 1`). `niri-session` re-execs
the login shell (`exec -l "$SHELL" -c '$0 -l ...'`) to guarantee a login
environment, which re-sources `.zprofile`. That second pass hit the VT1 condition
again and ran `exec niri-session` a second time → infinite loop. (On tty2 the VT1
guard was false, so no recursion — which is why it "worked" there.)

### 2. External monitor (DP-1) dead under niri.service
`~/.config/environment.d/graphics.conf` forced:
```
MESA_LOADER_DRIVER_OVERRIDE=iris
__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
```
`environment.d` is read by the **systemd --user manager** (so it applies to
`niri.service`) but **not** by a plain TTY login shell (so it never applied to
`exec niri --session`). On this dual-GPU laptop (card0+card1 / renderD128+renderD129)
forcing `iris` broke EGL init on the second GPU:
```
Failed to initialize EGL ... falling back to primary gpu
DP-1 ... error creating DRM compositor ... AccessError "Error testing state" card0 EINVAL
No supported renderer buffer format found
```
→ degraded renderer → the 3440x1440@160 atomic commit failed → DP-1 disabled.
This was the entire reason niri-session "never worked with the external monitor",
not niri-session itself.

## Changes made

| # | File / action | Change |
|---|---|---|
| 1 | `~/.config/environment.d/graphics.conf` | Commented out `MESA_LOADER_DRIVER_OVERRIDE=iris` and `__EGL_VENDOR_LIBRARY_FILENAMES` (kept `EGL_PLATFORM=wayland`). Fixes DP-1 under `niri.service`. |
| 2 | `~/.zprofile` (real: `dotfiles/zsh/.zprofile`) | Added `NIRI_LAUNCHED` sentinel guard (fixes tty1 hang) and switched `exec niri --session` → `exec niri-session`. |
| 3 | `~/.config/niri/config.kdl` (real: `dotfiles/niri/.config/niri/config.kdl`) | Commented out `spawn-sh-at-startup ".runall.sh"`; enabled `spawn-at-startup` for `cycle-wallpaper-niri.sh`. |
| 4 | `niri.service.wants/dms.service` | Removed the symlink — mako stays the notifier (mako & dms both claimed `org.freedesktop.Notifications`). The dms unit file itself is untouched. |
| 5 | live systemd user manager | Cleared stale `MESA_LOADER_DRIVER_OVERRIDE` / `__EGL_VENDOR_LIBRARY_FILENAMES` (lingering is enabled, so the manager persists across logins); ran `daemon-reload`. `niri validate` → config is valid. |

### Decisions
- **graphics.conf**: removed the two override lines (matches the working bare env).
- **Notifier**: mako (matches `makoctl` binds); dms dropped from wants.
- **Wallpaper**: `spawn-at-startup` (one-shot action, also bound to `Mod+Alt+w`).

## How to test
Log fully out of niri and log back in from **tty1** (fresh login required to pick up
the new launch path):
```sh
systemctl --user is-active niri.service              # -> active
systemctl --user is-active graphical-session.target  # -> active
niri msg outputs | grep -A1 DP-1                     # -> Current mode: 3440x1440 @ 159.962
systemctl --user status mako waybar swayidle qpwgraph ssh-agent bluetooth-battery-monitor
notify-send test                                     # mako should show it
```
Confirm: external monitor lights up, waybar + wallpaper appear, notifications work.

### Rollback
In `dotfiles/zsh/.zprofile`, re-enable `exec niri --session` and comment
`exec niri-session` (leave the `NIRI_LAUNCHED` guard — harmless), then log in again.

## Follow-up: picom autostart warning (fixed)
After switching to `niri-session`, a "picom Warning!" popup appeared at login.
Cause: `niri.service` activates `xdg-desktop-autostart.target`, which runs XDG
`*.desktop` autostart entries — including the system-wide
`/etc/xdg/autostart/picom.desktop` (shipped by the picom package). Under the old
`exec niri --session` that target was never activated, so the entry was dormant.
picom is an X11 compositor with no role under niri (Wayland).

Fix: created `~/.config/autostart/picom.desktop` with `Hidden=true`, which masks the
system entry so the XDG autostart generator no longer launches it (verified: no
`app-picom@autostart.service` is generated after `daemon-reload`). No system files
touched.

Note: `~/.config/autostart/remmina-applet.desktop` will now also autostart under niri
for the same reason — review/remove it the same way (`Hidden=true`) if unwanted.

## Follow-up: tty1 login warnings (redirected to a log)
After switching to `niri-session`, tty1 showed benign warnings at login: one
`import-environment` deprecation line (emitted by `/usr/bin/niri-session` running
`systemctl --user import-environment` with no args) plus 7 `LESS_TERMCAP_*`
"contains control characters" notices (those vars are exported from `.zshenv` and
contain raw `\E[` escape codes). niri starts fine regardless.

Fix (chosen): redirect niri-session's own output to a log file so tty1 stays clean
and the log is easy to grab. In `dotfiles/zsh/.zprofile`:
```sh
mkdir -p "$HOME/.local/state/niri"
exec niri-session >"$HOME/.local/state/niri/session.log" 2>&1
```
`>` truncates each login (always the latest session). niri's compositor logs are
unaffected (`journalctl --user -u niri.service`). To inspect:
`cat ~/.local/state/niri/session.log`.

## Things to watch / follow-ups
- **qpwgraph / ssh-agent ordering**: these units lack `After=graphical-session.target`,
  so under `niri.service.wants` they may start in parallel with the compositor.
  qpwgraph needs `WAYLAND_DISPLAY`; if it intermittently fails to appear, add
  `PartOf=graphical-session.target` + `After=graphical-session.target` to
  `~/.config/systemd/user/qpwgraph.service` (it has `Restart=on-failure`, so it
  usually self-recovers meanwhile).
- `~/.runall.sh` still exists but is no longer referenced — safe to delete once the
  new setup is confirmed.
