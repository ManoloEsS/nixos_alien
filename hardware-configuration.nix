# ALIEN ONLY: installation-specific hardware; never use this file for remote.
# After reinstall, compare both installer files in /etc/nixos and reconcile
# kernel modules, CPU, root/boot UUIDs, LUKS unlocks, and any disk swap.
# Generated files can omit LUKS settings kept in /etc/nixos/configuration.nix.
# Regenerating or replacing this file can remove manually reconciled settings.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Verify root mapper and LUKS UUID against the new installation.
  fileSystems."/" =
    { device = "/dev/mapper/luks-d7bc1be3-1c9d-4988-8b84-68255711f9b5";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-d7bc1be3-1c9d-4988-8b84-68255711f9b5".device = "/dev/disk/by-uuid/d7bc1be3-1c9d-4988-8b84-68255711f9b5";

  # Verify the EFI filesystem UUID and mountpoint.
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5052-F320";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # No disk swap on this installation; review if the installer creates any.
  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
