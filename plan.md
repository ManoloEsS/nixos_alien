# NixOS workstation plan

Adapt the useful workstation behavior from Fedora Atomic to NixOS, preferring
NixOS modules, Home Manager, and project-specific development shells over
distribution-specific mechanisms. Track runtime checks separately from what
the configuration declares.

## Working on alien

- [x] Boot the fresh NixOS installation with encrypted root and systemd-boot.
- [x] Apply the locked NixOS and Home Manager configuration; retain GNOME as a
  fallback alongside GDM, Niri, and Noctalia.
- [x] Configure Brave as the default browser and use Alacritty for the Niri
  terminal shortcut. Keep Ghostty installed with its own configuration.
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

## Next work

- [ ] Test the firewall on an untrusted network, including Tailscale access and
  LAN SSH denial; test home access again after reconnecting.
- [ ] Exercise Go, Python, C, and Rust LSPs and formatters in real projects.
- [ ] Create a Nix dev shell for a real project and evaluate direnv's workflow.
- [x] Enable and confirm zram swap; disk-backed swap and hibernation are not planned.
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
- [ ] Finish the dendritic shared workstation and host profiles. The workspace
  refactor builds for Alien but has not been synchronized or activated there.
  The E14 module is preliminary and needs installation-specific hardware and
  storage, boot choices, state versions, and a separate battery-limit design.
- [ ] Review backups of data outside the flake: secrets, browser profiles,
  NetworkManager profiles, Neovim plugins, and mutable application state.

Application screen sharing is a nice-to-have, not a parity requirement; test
the desktop portals if that workflow becomes useful.

Docker and Docker Compose are declared for the shared workstation, using sudo
rather than docker-group access; activation and runtime testing are pending.
Published container ports require separate firewall review. Flatpak
applications and RDP are not required by default. A separate automated
workstation verification phase is not currently planned.
