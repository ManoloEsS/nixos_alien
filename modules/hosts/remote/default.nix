# REMOTE (E14) ONLY: after reinstall, review the adjacent hardware file,
# bootloader, and internal keyboard ID in ./preferences.nix.
{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./preferences.nix ];

  networking.hostName = "remote";

  # Confirm the new installation uses UEFI/systemd-boot before keeping these.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # Keep installation state versions for data compatibility; do not bump them
  # as an upgrade. For a fresh install, review the installer's values.
  system.stateVersion = "26.05";
  home-manager.users.manoloess.home.stateVersion = "26.05";
}
