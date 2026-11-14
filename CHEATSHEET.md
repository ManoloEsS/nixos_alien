# NixOS command cheatsheet

Run repository commands from `~/nixos_alien`. The workspace checkout is the
source of truth; commit and push there, then synchronize each laptop deliberately.
Use `alien` for the Alienware and `remote` for the ThinkPad E14.

## Check the repository

```sh
cd ~/nixos_alien
git status --short --branch
git log -1 --oneline
```

Git-backed flakes need **new files added to the Git index** before Nix can see
them. Review local changes before pulling or overwriting anything.

## Build and switch

Build first. A switch changes the running system and may restart services;
perform it locally with keyboard/display access, especially for network changes.

**Alienware:**

```sh
nix build --no-link .#nixosConfigurations.alien.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#alien
```

**ThinkPad E14:**

```sh
nix build --no-link .#nixosConfigurations.remote.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#remote
```

Both outputs contain installation-specific disk identifiers. After reinstalling,
follow `installation_steps.md` and reconcile hardware and LUKS settings first.

## Update flake inputs

Updating changes `flake.lock` and may update system packages. Review the diff,
build the appropriate host, then commit/synchronize before switching.

```sh
nix flake update nixpkgs       # system packages
nix flake update nvim-config   # pinned Neovim configuration
nix flake update               # all inputs
git diff -- flake.lock
```

Herdr is pinned to a release tag in `flake.nix`: change that tag first, then
run `nix flake update herdr`. Updating the Neovim input does not by itself pin
or update its separately managed plugins and Tree-sitter parsers.

## Generations and recovery

```sh
nixos-rebuild list-generations
readlink /run/current-system
readlink /run/booted-system
```

At boot, systemd-boot can start a previous generation. A local administrator
can also switch to the previous system profile with:

```sh
sudo nixos-rebuild switch --rollback
```

Rollback changes the running system and services, but doesn't restore personal
data, credentials, NetworkManager changes, or browser profiles. Keep installer
media and backups. Garbage collection can remove old generations and rollback
options; review what you need before deleting anything.

## Project development shells

From a trusted project containing a dev-shell flake:

```sh
nix develop       # enter the project's shell; exit to leave
direnv allow      # approve and auto-load its .envrc when entering the directory
```

Only approve `.envrc` files you trust: they can execute commands. Project
`flake.lock` files pin Nix inputs independently of the workstation lock.

## Docker and Compose

Docker daemon access requires `sudo`. Published ports can be reachable outside
the host firewall's usual rules; bind local-only services to loopback and review
each project's port mappings.

```sh
sudo docker ps
sudo docker images
sudo docker compose ps
sudo docker compose up -d
sudo docker compose logs -f
sudo docker compose down
```

Run Compose commands from the project directory. `up` creates or changes
containers and networks; `down` stops and removes the project's containers and
networks. Don't add volume-removal options unless you intend to delete data.

## Services, networking, and storage

```sh
systemctl --failed
systemctl status docker NetworkManager firewalld tailscaled
systemctl --user status niri pipewire wireplumber xdg-desktop-portal
tailscale status
firewall-cmd --get-active-zones
nmcli connection show --active
swapon --show
lsblk -f
```

For the E14, inspect battery charge limits without changing them:

```sh
cat /sys/class/power_supply/BAT0/charge_control_start_threshold
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
```

## Notes

- `sudo` commands require administrator access. Review commands before running
  them, particularly on a new installation.
- A flake does not restore SSH keys, keyrings, Wi-Fi credentials, browser data,
  or other personal files. Keep separate backups; never put secrets in Nix files.
- See `installation_steps.md` for fresh-install steps and optional auto-login.
