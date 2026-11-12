# Installation steps

These steps describe bringing the `alien` workstation configuration onto a
fresh NixOS installation. They require network access, local keyboard and
display access, and an administrator account. The configuration is specific to
the current laptop and user; adapting it to another host requires review.

## Choose the machine first

| Machine | Desired hostname | Flake output | Status |
| --- | --- | --- | --- |
| Alienware | `alien` | `alien` | Available; reconcile the new hardware configuration before building. |
| ThinkPad E14 | `remote` | Not yet available | The E14 feature composition exists, but a real `remote` output and installation-specific settings must be added before these steps can build it. |

Do **not** use Alien's flake output or hardware identifiers to install the E14.
The sections below give the working Alien path and identify the E14-specific
steps that must be completed once its output is implemented. The E14 workflow
has not yet been installation-tested.

## 1. Prepare and install NixOS

Back up any data and keys you need. Partitioning, formatting, or recreating a
LUKS volume can permanently erase existing data. Keep installer media available
for recovery, and decide what to preserve before changing any disk.

Use the graphical NixOS installer and select GNOME as the initial desktop.
Create the normal user `manoloess`, give it administrator privileges, and
set a password. Choose hostname `alien` for Alien or `remote` for the E14;
the eventual repository host profile must match the intended hostname.

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

If Git is not installed in the fresh GNOME system, temporarily obtain it with
Nix and clone instead:

```sh
nix-shell -p git --run 'git clone https://github.com/ManoloEsS/nixos_alien.git /home/manoloess/nixos_alien'
```

Use only one of the clone commands; neither is intended to overwrite an
existing directory. Change into the checkout for the remaining steps:

```sh
cd /home/manoloess/nixos_alien
```

Use the correct repository revision and `flake.lock`. Uncommitted changes in
another checkout are not present in the remote clone. Review existing files
before replacing them; Git-backed flakes only include files known to Git, so
new configuration files need to be added to the Git index before building.

Compare the freshly generated `/etc/nixos/hardware-configuration.nix` and the
actual disks with this repository's `hardware-configuration.nix` and Alien's
host profile in `modules/hosts/alien`. Reconcile the LUKS, root, EFI boot, and swap devices;
freshly formatted volumes generally have new UUIDs. Also review the host
name, user, boot loader, keyd keyboard ID, and hardware-specific graphics and
desktop settings. Do not copy disk identifiers or keyboard IDs blindly.

### Alien: reconcile the generated hardware file

The graphical installer writes the new machine's hardware configuration under
`/etc/nixos`. Inspect both files before replacing or merging anything:

```sh
cat /etc/nixos/hardware-configuration.nix
cat hardware-configuration.nix
lsblk -f
```

For a straightforward fresh Alien installation, the generated file can be the
starting point for the repository's `hardware-configuration.nix`; preserve any
intentional, still-applicable customizations after reviewing both files. Save a
copy of the repository file outside the checkout first, then copy the generated
file and review the diff. Do not run the copy commands until you have confirmed
that the backup filename below does not already exist:

```sh
cp hardware-configuration.nix "$HOME/hardware-configuration.nix.before-reinstall"
cp /etc/nixos/hardware-configuration.nix hardware-configuration.nix
git diff -- hardware-configuration.nix
```

If the backup path already exists, choose a different name rather than
overwriting it. Verify that the generated root, LUKS, boot, swap, platform, and
kernel-module settings describe **this** installation. Also compare the
installer's bootloader settings in `/etc/nixos/configuration.nix` with
`modules/hosts/alien/default.nix`; do not assume systemd-boot is correct if you
chose a different loader. Confirm the internal keyboard ID and the two state
versions in that host file as well.

### E14 (`remote`): preparation still required

Before using this guide to activate the E14, add and review a `remote` NixOS
flake output that selects `flake.modules.nixos.thinkpad-e14` and a separate
E14 hardware file. After a new installation, copy or reconcile the generated
`/etc/nixos/hardware-configuration.nix` into that E14-specific file, **not**
Alien's file. Set `networking.hostName` to `remote`, use the installer-selected
bootloader, and choose the installation's system and Home Manager state
versions. Confirm the keyd internal-keyboard ID on the installed system.

These are implementation prerequisites, not completed commands: `#remote`
currently does not exist. Do not proceed with an E14 switch until the host
output and its actual hardware configuration have been added and reviewed.

The flake output and paths below assume the user is `manoloess` and the host
output is `alien`; adapt them deliberately for other systems. Preserve the
fresh installation's `system.stateVersion` and choose Home Manager's
`home.stateVersion` appropriately rather than treating either as an upgrade
switch. Alien's values are in `modules/hosts/alien/default.nix`.

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

Enable MagicDNS in the Tailscale admin console and ensure the client you use to
connect accepts Tailscale DNS. Tailscale initially derives its machine name from
the OS hostname, but existing or duplicate devices can retain another name or
receive a suffix. Check each device in the Tailscale admin console; rename its
**machine name** to `alien` or `remote` there if necessary. Do not remove an
old device merely to free a name without first verifying it is safe to do so.
Changing an OS hostname alone does not guarantee an existing Tailscale machine
name immediately changes.

Check the intended home profile and active zones:

```sh
nmcli -g connection.zone connection show uuid <HOME_WIFI_UUID>
firewall-cmd --get-default-zone
firewall-cmd --get-active-zones
tailscale status
tailscale get ssh
hostnamectl --static
```

From another authenticated tailnet device, after verifying the machine names,
host keys, SSH access policy, and username, try:

```sh
ssh manoloess@alien
ssh manoloess@remote
```

Short names depend on MagicDNS/search-domain setup and can also be overridden
by local SSH aliases or host entries. If they resolve incorrectly, use the
full `*.ts.net` name shown in the Tailscale admin console or the device's
Tailscale IP, and verify its SSH host key before connecting. Each command only
works once the corresponding machine is installed, online, authenticated, and
permitted by the tailnet policy.

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

## Optional: enable automatic login on one machine

Automatic login is a per-host choice. It reduces physical-access protection and
can leave the login keyring locked; test keyring behavior and keep the disk
encryption passphrase and local recovery access available. Do not apply it to a
shared host module unless both machines should use it.

For Alien, add the following settings inside
`modules/hosts/alien/default.nix`, then rebuild and switch using the commands
above:

```nix
services.displayManager.autoLogin.enable = true;
services.displayManager.autoLogin.user = "manoloess";
```

For the E14, add the same settings to its **host-specific** NixOS module once
its `remote` output exists, and build/switch that output instead. Verify which
desktop session GDM automatically starts; automatic login does not guarantee
Niri is selected. Remove or disable the settings and rebuild to turn it off.

See [README.md](README.md) for input updates, the editable Neovim checkout,
Herdr, and additional recovery notes; [plan.md](plan.md) tracks remaining work.
