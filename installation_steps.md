# NixOS installation

Use the correct host throughout: **Alienware = `alien`**; **ThinkPad E14 =
`remote`**. Never use Alien's hardware file or `#alien` output on the E14.

## 1. Install NixOS

Back up personal data, SSH keys, keyrings, and encryption recovery information.
Disk formatting can erase data; keep the installer USB for recovery.

Use the graphical installer with GNOME. Create administrator `manoloess` and
choose hostname `alien` or `remote`. Boot the installation, unlock the disk,
connect to the internet, and confirm `sudo` works.

## 2. Clone this repository

Run this in a terminal. If the destination already exists, inspect it first;
the command temporarily supplies Git if it is not already installed.

```sh
nix-shell -p git --run 'git clone https://github.com/ManoloEsS/nixos_alien.git /home/manoloess/nixos_alien'
cd /home/manoloess/nixos_alien
```

Use the intended committed revision and `flake.lock`. Git-backed flakes require
new configuration files to be added to Git's index before building.

## 3. Review this installation's hardware

Inspect **both** installer files and the actual devices. New installations can
have different disk UUIDs, bootloaders, and encrypted swap settings.

```sh
cat /etc/nixos/hardware-configuration.nix
cat /etc/nixos/configuration.nix
lsblk -f
```

Reconcile the generated hardware configuration with the correct file below;
back up the existing file first. Review root, `/boot`, every LUKS unlock,
swap, bootloader, keyboard ID, and both state versions before continuing.

| Host | Hardware file | Host settings |
| --- | --- | --- |
| `alien` | `hardware-configuration.nix` | `modules/hosts/alien/default.nix` |
| `remote` | `modules/hosts/remote/hardware-configuration.nix` | `modules/hosts/remote/default.nix` |

**E14 encrypted swap:** the installer may put its LUKS unlock setting in
`/etc/nixos/configuration.nix`, not the generated hardware file. Preserve or
update it in the `remote` hardware file if the new installation uses that swap;
replacing the hardware file can remove it. Never reuse old UUIDs without review.

## 4. Assign trusted home Wi-Fi

Only for a trusted home network, find its UUID and assign it to the NixOS zone
that allows SSH. Other networks use the restrictive default zone.

```sh
nmcli -f NAME,UUID,TYPE connection show
sudo nmcli connection modify uuid <HOME_WIFI_UUID> connection.zone nixos-fw-default
```

Replace `<HOME_WIFI_UUID>` with the new installation's UUID. This assignment and
the Wi-Fi credentials are local NetworkManager state, not stored in the repo.

## 5. Build and switch locally

Choose **only the commands for this machine**. Build first; switch only after
it succeeds and hardware and boot settings have been reviewed. Keep local
keyboard/display access: switching may interrupt SSH or restart services.

**Alienware:**

```sh
nix --extra-experimental-features 'nix-command flakes' build --no-link /home/manoloess/nixos_alien#nixosConfigurations.alien.config.system.build.toplevel
sudo env NIX_CONFIG='experimental-features = nix-command flakes' nixos-rebuild switch --flake /home/manoloess/nixos_alien#alien
```

**ThinkPad E14:**

```sh
nix --extra-experimental-features 'nix-command flakes' build --no-link /home/manoloess/nixos_alien#nixosConfigurations.remote.config.system.build.toplevel
sudo env NIX_CONFIG='experimental-features = nix-command flakes' nixos-rebuild switch --flake /home/manoloess/nixos_alien#remote
```

Review Home Manager file conflicts before switching. A successful build does
not prove boot or desktop behavior; keep the previous boot generation available.

## 6. Reboot and finish

Reboot locally, unlock the encrypted devices, and choose Niri at the GDM login
screen. If the new generation fails, select the previous working generation in
systemd-boot; keep the installer USB available.

Test Wi-Fi, keyboard, terminal shortcut, audio, Docker, and browser. On the E14,
enable its optional charge limit in Noctalia and test travel mode separately.
Restore personal data and credentials from your backups; they are not in Nix.

## 7. Set up Tailscale

Authenticate the new machine and follow the displayed instructions:

```sh
sudo tailscale up --ssh
tailscale status
```

Enable MagicDNS and confirm the machine names are `alien` and `remote` in the
Tailscale admin console. Existing devices may need renaming; don't remove old
devices without checking. Verify SSH host keys and tailnet permissions before
connecting as `manoloess@alien` or `manoloess@remote`.

## Optional: automatic login

Add these settings to **only the desired host's** `default.nix`, then build and
switch that host again. Automatic login reduces physical security, may leave
the keyring locked, and does not guarantee that GDM selects Niri.

```nix
services.displayManager.autoLogin.enable = true;
services.displayManager.autoLogin.user = "manoloess";
```

See `README.md` for recovery and updates. Never put passwords, encryption keys,
or other secrets in this repository or the Nix store.
