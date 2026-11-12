# NixOS workstation

NixOS configuration for `alien`, using flakes and Home Manager for a Niri and
Noctalia workstation. Brave Origin is the configured default browser, with
standard Brave retained during the transition; Alacritty is the Niri
terminal shortcut, with Ghostty retained separately. See [plan.md](plan.md)
for current status and remaining work, and [installation steps](installation_steps.md)
for the fresh-install workflow and manual configuration.

This workspace repository is the source of truth. The working copy on the
laptop is `/home/manoloess/nixos_alien`; synchronize changes deliberately and
inspect both copies before overwriting either. The current target directory was
copied from the workspace and is not necessarily a Git checkout.

## Host profiles

The flake uses flake-parts and import-tree to discover top-level modules in
`modules/dendritic`. The shared `workstation.nix` composition selects features
such as desktop, networking, laptop power, Neovim, shell, and audio. It also
imports the remaining shared settings in `configuration.nix`; `home.nix` holds
additional shared Home Manager settings. Discovery defines features but does
not enable every feature on every host.

The `alien` output selects the workstation composition and
`modules/hosts/alien`, which contains its hostname, boot choices, keyboard
configuration, and system and Home Manager state versions. That host profile
imports the existing generated `hardware-configuration.nix`. Generated hardware
files and other ordinary NixOS modules are outside the auto-discovered tree.

The shared dendritic configuration has been activated on Alien.

The preliminary E14 composition in `modules/dendritic/thinkpad-e14.nix` selects
the shared workstation and `modules/hosts/thinkpad-e14`, which records the E14's
Wi-Fi and internal-keyboard preferences and changes its Niri terminal shortcut
to Ghostty. Alien retains Alacritty. The `remote` output adds the current E14
installation's hardware, boot, encrypted disk-swap, hostname, and state-version
settings. It must be reconciled with any future reinstall and has not yet been
activated or boot-tested. Its preliminary battery feature
declares 75/80 limits and restores them at boot only when UPower's saved state
is enabled; on a fresh install the limit must be enabled explicitly. This
behavior has not been tested on NixOS.

## Fresh installation and encryption

Install and boot a basic NixOS system before applying this host configuration.
Back up existing data before partitioning or formatting; either can destroy it.
The current laptop has a LUKS-encrypted root, a separate unencrypted EFI boot
partition, and no disk-backed swap. The configuration enables compressed
RAM-backed zram swap for memory pressure, not hibernation. Unlocking at boot
requires the disk passphrase; never
put passphrases or secrets in this repository or the Nix store.

Generate and review the new machine's hardware configuration. In particular,
reconcile root, LUKS, boot, and swap devices with the actual installation before
building or switching. The UUIDs in `hardware-configuration.nix` describe the
current installation only; recreating partitions generally changes them. Also
review the host name, keyboard ID, GPU, user, and boot loader. Do not copy the
existing host-specific values blindly to another machine.

Install the repository and its locked `flake.lock` on the target, then build
before activation. Flakes must be enabled; a basic installation may require
temporarily enabling the `nix-command` and `flakes` experimental features.
When using a Git-backed flake, add new source files to Git's index so Nix can
see them. Build and switch commands can download dependencies and use disk
space; switching requires administrator privileges and changes the running
system.

```sh
nix build --no-link /home/manoloess/nixos_alien#nixosConfigurations.alien.config.system.build.toplevel
sudo nixos-rebuild switch --flake /home/manoloess/nixos_alien#alien
```

After the initial switch, reboot when needed to test the new boot generation,
disk unlock, and desktop. Keep installer media and a local recovery path
available. NixOS generations do not replace backups or restore personal data.

## Network and remote access

NetworkManager manages connections. Firewalld uses a restrictive `drop`
default zone; the NixOS-generated `nixos-fw-default` zone allows the ports
declared by NixOS, currently including SSH and mDNS. On alien, the saved home
Wi-Fi profile is assigned to that zone. This profile assignment and the Wi-Fi
credentials are **mutable NetworkManager state**, not defined by the flake.
For a fresh installation, identify the correct home connection locally and
assign it to `nixos-fw-default`; do not assume an old connection UUID applies.
Review the generated zone before trusting a network.

Tailscale and its SSH preference are configured, but tailnet authentication and
access policy are separate from the flake. Complete authentication manually.
Fresh SSH connections over the home LAN and Tailscale were tested on alien; the
untrusted-network transition has not yet been tested. Be at the machine with
local access before changing firewall or networking settings.

## Neovim and shell

`flake.nix` follows `kickstart.nvim`'s `master` branch as a non-flake input;
`flake.lock` pins the deployed revision. Home Manager links the editor files
into `~/.config/nvim`, while leaving that directory writable for the
`vim.pack` lockfile. Nix supplies the configured language servers and
formatters on NixOS; Mason remains enabled in the editor configuration on
non-NixOS systems. Plugins and Tree-sitter parsers are still downloaded and
managed by Neovim, so they are not fully reproduced by this flake.

The old editable checkout is preserved at `~/kickstart.nvim` on alien. It had
uncommitted changes when moved; inspect its status before updating it. Edit and
commit editor changes in a separate checkout, push them to the tracked branch,
then update only the editor input and rebuild:

```sh
nix flake update nvim-config --flake /home/manoloess/nixos_alien
```

Home Manager also manages Bash integrations, Starship, zoxide, fzf, and direnv
with nix-direnv. Allow direnv environments only for projects you trust.
Project-specific development shells are preferred over recreating Fedora's
Toolbx by default.

## Updates and recovery

Review changes before updating inputs. A normal rebuild uses existing locked
revisions. Updating an input modifies `flake.lock`; synchronize that change
back to the source-of-truth repository before it is lost. Herdr is explicitly
pinned to the release tag in `flake.nix`: upgrading it requires changing that
tag, updating its input, building, and switching. Its upstream flake builds
from source, which can be slow.

The systemd-boot menu offers previous NixOS generations. If a new generation
fails to boot, select a previous entry; a local administrator can also roll
back using NixOS tools. Rollback does not necessarily undo mutable user data,
NetworkManager changes, credentials, or external services. Home Manager may
back up conflicting files with its configured `hm-backup` suffix, but inspect
conflicts and back up important data before activating changes.
