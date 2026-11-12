# REMOTE (E14) ONLY: installation-specific hardware; never use for Alien.
# After reinstall, compare both installer files in /etc/nixos and reconcile
# kernel modules, CPU, root/boot UUIDs, LUKS unlocks, and disk swap.
# The installer may put encrypted-swap unlock settings in configuration.nix.
# Regenerating or replacing this file can remove manually added settings.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Verify root mapper and LUKS UUID against the new installation.
  fileSystems."/" =
    { device = "/dev/mapper/luks-6bb7d42f-6494-43e1-861c-0e381e40e5d1";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-6bb7d42f-6494-43e1-861c-0e381e40e5d1".device = "/dev/disk/by-uuid/6bb7d42f-6494-43e1-861c-0e381e40e5d1";

  # Added from the installer's configuration.nix: required to unlock disk swap.
  # Regenerating this file can remove this setting; reconcile it after reinstall.
  boot.initrd.luks.devices."luks-7eb0270c-56c3-41eb-b76d-5531d0467176".device = "/dev/disk/by-uuid/7eb0270c-56c3-41eb-b76d-5531d0467176";

  # Verify the EFI filesystem UUID and mountpoint.
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2AAA-8778";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # Match this mapper and its unlock definition above to the installed swap;
  # remove both declarations if a future installation has no disk swap.
  swapDevices =
    [ { device = "/dev/mapper/luks-7eb0270c-56c3-41eb-b76d-5531d0467176"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
