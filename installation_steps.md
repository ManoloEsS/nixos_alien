# Installation steps

These steps describe bringing the `alien` workstation configuration onto a
fresh NixOS installation. They require network access, local keyboard and
display access, and an administrator account. The configuration is specific to
the current laptop and user; adapting it to another host requires review.

## 1. Prepare and install NixOS

Back up any data and keys you need. Partitioning, formatting, or recreating a
LUKS volume can permanently erase existing data. Keep installer media available
for recovery, and decide what to preserve before changing any disk.

Install a basic NixOS system and verify that it boots, unlocks its encrypted
root, connects to the network, and lets the intended user use sudo. The current
alien installation uses UEFI/systemd-boot, encrypted root, a separate
unencrypted EFI boot partition, and no disk-backed swap. The NixOS configuration
enables RAM-backed zram swap for memory pressure, not hibernation. Choose the disk layout explicitly;
do not assume the old layout or identifiers apply after reinstalling.

Save encryption recovery information securely. Never put LUKS passphrases,
Wi-Fi passwords, Tailscale credentials, or other secrets in this repository or
the Nix store. NixOS generations are not backups of personal data or secrets.

## 2. Get and adapt the configuration

Obtain the repository at `/home/manoloess/nixos_alien`. For a fresh account,
one option is to clone it over HTTPS:

```sh
git clone https://github.com/ManoloEsS/nixos_alien.git /home/manoloess/nixos_alien
```

Use the correct repository revision and `flake.lock`. Uncommitted changes in
another checkout are not present in the remote clone. Review existing files
before replacing them; Git-backed flakes only include files known to Git, so
new configuration files need to be added to the Git index before building.

Compare the freshly generated `/etc/nixos/hardware-configuration.nix` and the
actual disks with this repository's `hardware-configuration.nix` and
`configuration.nix`. Reconcile the LUKS, root, EFI boot, and swap devices;
freshly formatted volumes generally have new UUIDs. Also review the host
name, user, boot loader, keyd keyboard ID, and hardware-specific graphics and
desktop settings. Do not copy disk identifiers or keyboard IDs blindly.

The flake output and paths below assume the user is `manoloess` and the host
output is `alien`; adapt them deliberately for other systems. Preserve the
fresh installation's `system.stateVersion` and choose Home Manager's
`home.stateVersion` appropriately rather than treating either as an upgrade
switch.

## 3. Assign the trusted home Wi-Fi profile

Connect to home Wi-Fi using NetworkManager. The NixOS configuration will use
firewalld's `drop` zone for unassigned networks. The generated
`nixos-fw-default` zone currently permits SSH and mDNS, so assign **only a
network you trust** to it. Identify the home connection's UUID on the new
installation:

```sh
nmcli -f NAME,UUID,TYPE connection show
```

Replace `<HOME_WIFI_UUID>` below with that profile's UUID, not an old machine's
UUID. This changes the saved NetworkManager connection; it does not put Wi-Fi
credentials in the repository.

```sh
sudo nmcli connection modify uuid <HOME_WIFI_UUID> connection.zone nixos-fw-default
```

The profile and its zone assignment are mutable system state, not part of the
flake. Recreate the assignment after reinstalling. A profile name or SSID alone
does not prove that a network is trustworthy. Review the zone's allowed
services before trusting any network. Other connections should remain in the
restrictive default unless explicitly reviewed.

## 4. Build and activate

On a basic NixOS installation, enable flakes and the Nix CLI temporarily for
the first build and switch. The target configuration enables them permanently.
The build may download packages and write to the Nix store; the switch changes
the running system, services, firewall, and boot configuration.

```sh
nix --extra-experimental-features 'nix-command flakes' build --no-link /home/manoloess/nixos_alien#nixosConfigurations.alien.config.system.build.toplevel
sudo env NIX_CONFIG='experimental-features = nix-command flakes' nixos-rebuild switch --flake /home/manoloess/nixos_alien#alien
```

Run the switch locally with a recovery path available: firewall and network
changes can interrupt SSH. Home Manager may back up conflicting files with its
configured `hm-backup` suffix; review existing user files and back up anything
important first. A successful build or switch does not prove that the next boot
or desktop session will work.

Reboot when appropriate, unlock the disk, and select Niri at the GDM login
screen. GNOME remains available as a fallback. If the new system does not boot,
select a previous NixOS generation from the systemd-boot menu. NetworkManager
profile changes and other mutable data are not necessarily rolled back.

## 5. Authenticate Tailscale and check remote access

The configuration enables `tailscaled` and declares the Tailscale SSH
preference, but it cannot authenticate the device or grant tailnet access.
For a fresh, unauthenticated device, authenticate interactively:

```sh
sudo tailscale up --ssh
```

Follow the authentication instructions and ensure your tailnet policy allows
the intended SSH access. On an already configured device, review its
existing preferences before running `tailscale up`: non-default preferences
may need to be specified, and changing SSH settings can interrupt sessions.

Check the intended home profile and active zones:

```sh
nmcli -g connection.zone connection show uuid <HOME_WIFI_UUID>
firewall-cmd --get-default-zone
firewall-cmd --get-active-zones
tailscale status
tailscale get ssh
```

Confirm a **new** SSH connection over the home LAN and another over Tailscale
from a trusted client. The untrusted-network transition has not yet been
validated for this configuration; when possible, test that LAN SSH is blocked
there and Tailscale still works, with local recovery access available. Do not
assume an existing SSH session proves new connections are allowed.

## 6. Complete the user workflow

- Open a new terminal and test the shell and Alacritty shortcut. Some session
  variables may require logging out and back in.
- The Neovim configuration is a pinned flake input. Its first launch may
  download plugins and Tree-sitter parsers into user data; those downloads are
  not fully pinned by the system flake. Test the language tooling you use.
- Browser profiles, SSH keys, keyrings, and other personal data are not restored
  by the flake. Restore them securely from your own backups as needed.
- Automatic login is a per-machine choice and is not enabled by this workflow.
  It reduces physical-access protection and can affect keyring unlocking.
- Only enable a battery charge limit after confirming that the specific
  hardware supports it. The Fedora ThinkPad threshold setup is not applied to
  alien.

See [README.md](README.md) for input updates, the editable Neovim checkout,
Herdr, and additional recovery notes; [plan.md](plan.md) tracks remaining work.
