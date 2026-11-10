# Reference backups (not wired into home-manager)

Read-only copies of live config files that apps rewrite at runtime
(kwin/kscreen). They cannot be managed via `xdg.configFile` because HM
symlinks point into the read-only Nix store and runtime writes would
break. To restore: copy the file back to `~/.config/` and re-login.

- `kwinoutputconfig.json` — monitor setup (eDP-1 + DP-1, brightness,
  color, scaling) captured 2026-11-10.
