# NixOS workstation plan

Adapt the functionality of `atomic_laptop` for NixOS, keeping the setup minimal, reproducible, and suitable for multiple machines. Add features in small, verified steps.

## Done on alien

- [x] Pin Nixpkgs, Home Manager, and Noctalia with a flake and lock file.
- [x] Configure GDM, Niri, and Noctalia; retain GNOME as a fallback and disable its core-app collection.
- [x] Manage Niri, Noctalia, and Ghostty configurations with Home Manager.
- [x] Install Ghostty and use NVIDIA offloading for its Niri shortcut; keep Kitty as a fallback.
- [x] Install JetBrains Mono Nerd Font and configure the pointer theme.
- [x] Install Brave and Nautilus; manage Brave's default browser associations.
- [x] Configure networking, Bluetooth, power profiles, UPower, PipeWire, and OpenSSH.
- [x] Install Git, GitHub CLI, and Neovim.

## Desktop and usability

- [ ] Restore or replace the universal clipboard shortcuts and their dependencies.
- [ ] Adapt the touchpad toggle and its mutable state to work with the managed Niri configuration.
- [ ] Replace or remove the Fedora-specific update shortcut; review other copied shortcuts and scripts.
- [ ] Verify the Brave picture-in-picture rule and other desired Niri/Noctalia functionality.
- [ ] Decide whether to keep the GNOME fallback after Niri is established.

## Shell and development tools

- [ ] Choose and declaratively install the desired CLI tools from the Fedora setup.
- [ ] Adapt Bash settings, aliases, and functions without Fedora, Mise, or Toolbx assumptions.
- [ ] Manage Starship, tmux, Yazi, and Herdr configuration if desired.
- [ ] Restore the separate Neovim configuration and decide how to manage its plugins and dependencies reproducibly.
- [ ] Explore project-specific Nix development shells for runtimes and build tools.

## Remote access and containers

- [ ] Decide whether to configure Tailscale and Tailscale SSH.
- [ ] Review the effective firewall and decide on a trusted-network SSH policy without losing access.
- [ ] Decide whether to configure rootless Podman, Compose, and a container-based development workflow.
- [ ] Decide whether FreeRDP and the remote desktop launcher are needed.

## Multiple machines and maintenance

- [ ] Separate shared desktop and user settings from alien-specific hardware and GPU settings.
- [ ] Add `remote` and `desktop` configurations when their hardware and requirements are known.
- [ ] Establish a deliberate flake update, rebuild, verification, and rollback workflow.
- [ ] Review state outside the flake, including browser profiles, Noctalia overrides, credentials, and editor plugins.
- [ ] Evaluate keyd remapping, Wi-Fi power saving, and battery charge limits per machine; do not copy hardware-specific settings blindly.
