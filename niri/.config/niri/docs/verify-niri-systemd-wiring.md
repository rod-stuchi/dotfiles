# Verify the niri systemd session wiring

Companion checks for the [`.runall.sh` → systemd user services
migration](claude-summary-changes.md). Run these after a fresh login to confirm
`niri-session` correctly activates `graphical-session.target` and pulls in the
wanted user services on its own (no `.runall.sh`).

## Checks

```sh
# 1. The core units should report `active` (not `inactive`):
systemctl --user is-active niri.service
systemctl --user is-active graphical-session.target

# 2. The wanted services should have come up automatically via
#    niri.service.wants/ — list what niri.service pulls in:
systemctl --user list-units 'niri.service.wants/*' --all

# 3. Spot-check the individual services are running:
systemctl --user status mako waybar swayidle qpwgraph ssh-agent \
  niri-portal-resize.service
```

## Expected

- `niri.service` and `graphical-session.target` → `active`.
- The `list-units` output shows the `*.wants` symlinks (mako, waybar, swayidle,
  qpwgraph, ssh-agent, niri-portal-resize, …) as loaded/active.
- Each service in the `status` call is `active (running)`.
- `niri-portal-resize.service` running confirms the [floating file-chooser
  resize daemon](claude-portal-float-resize.md) starts with the session.

If anything is `inactive`, the wiring didn't take — re-check the migration steps
in [`claude-summary-changes.md`](claude-summary-changes.md).
