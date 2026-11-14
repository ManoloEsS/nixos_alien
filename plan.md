# NixOS workstation plan

Adapt the useful workstation behavior from Fedora Atomic to NixOS, preferring
NixOS modules, Home Manager, and project-specific development shells over
distribution-specific mechanisms. Track runtime checks separately from what
the configuration declares.

## Working on alien

- [x] Boot the fresh NixOS installation with encrypted root and systemd-boot.
- [x] Apply the locked NixOS and Home Manager configuration; retain GNOME as a
  fallback alongside GDM, Niri, and Noctalia.
- [x] Activate and test Brave Origin as the default browser on Alien; retain
  standard Brave and its profile during the transition. Alien uses Alacritty
  for the Niri terminal shortcut and keeps Ghostty installed.
- [x] Install JetBrains Mono Nerd Font, keyd for the internal keyboard, audio,
  Bluetooth, power services, and the Niri desktop helpers. The user confirmed
  the touchpad toggle and universal clipboard shortcuts work.
- [x] Install a flake-pinned Neovim configuration and Nix-managed language
  tools; confirm Lua LSP attachment and formatter availability.
- [x] Configure Bash, fzf, Starship, zoxide, direnv, and the selected CLI tools.
- [x] Install Herdr from its upstream flake and configure it; the user reports
  it works.
- [x] Authenticate Tailscale and verify fresh LAN and Tailscale SSH connections.
- [x] Switch to firewalld with a restrictive default and assign the home Wi-Fi
  profile to the NixOS zone allowing SSH and mDNS.
- [x] Activate the shared dendritic workstation configuration on Alien.
- [x] Install global Rust tools and verify rustc, Cargo, rust-analyzer, and rustfmt.
- [x] Test a Go dev shell with direnv, a project-specific Go version, `go test`,
  and Neovim gopls attachment in a small test project.
- [x] Activate Docker and Docker Compose with sudo-only daemon access; run the
  Docker hello-world container successfully.

## Next work

- [ ] Test the firewall on an untrusted network, including Tailscale access and
  LAN SSH denial; test home access again after reconnecting.
- [ ] Exercise language servers, formatters, and project shells in real projects
  as needed. Python, C, and Rust workflows remain untested.
- [x] Enable and confirm zram swap on Alien; it has no disk-backed swap, and
  hibernation is not configured.
- [ ] On a fresh installation, reconcile the generated hardware and filesystem
  settings with the host configuration before activating it.
- [ ] Decide whether plugin and Tree-sitter parser versions should also be
  Nix-managed; both currently remain mutable Neovim state.
- [ ] Review the remaining Bash functions and choose whether `herdev` should
  remain an alias for Herdr or represent a separate project workflow.
- [ ] Check audio after reboot and other desktop behavior as needed. Keep GNOME
  fallback until deliberately reconsidered.
- [ ] Review Wi-Fi powersave only if needed. Do not copy ThinkPad battery
  thresholds to alien; its previously inspected battery did not expose the
  relevant controls. Automatic login remains a per-machine decision.
- [x] Build, activate, and boot the E14 `remote` profile with its own hardware,
  encrypted disk swap, zram, and host settings.
- [ ] Test the E14 battery-limit and travel-mode toggle across reboots; the
  current hardware reports 75/80, but toggle persistence is unverified.
- [ ] Review backups of data outside the flake: secrets, browser profiles,
  NetworkManager profiles, Neovim plugins, and mutable application state.
- [ ] Review Tailscale machine naming: Alien currently uses `alien-1`, while
  the desired MagicDNS name is `alien`.

Application screen sharing is a nice-to-have, not a parity requirement. PipeWire
and the Niri-compatible desktop portals are configured; browser screen sharing
has not been tested end-to-end. PipeWire JACK support is enabled.

Docker and Docker Compose are active on Alien, using sudo rather than
docker-group access. Compose has not yet been tested with a project, and
published container ports require separate firewall review. Flatpak
applications and RDP are not required by default. A separate automated
workstation verification phase is not currently planned.
