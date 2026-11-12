{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "remote";

  # Match the E14 installer's UEFI/systemd-boot setup.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # The installer declared this encrypted swap in configuration.nix rather
  # than its generated hardware file. Keep it alongside the shared zram swap.
  boot.initrd.luks.devices."luks-7eb0270c-56c3-41eb-b76d-5531d0467176".device =
    "/dev/disk/by-uuid/7eb0270c-56c3-41eb-b76d-5531d0467176";

  system.stateVersion = "26.05";
  home-manager.users.manoloess.home.stateVersion = "26.05";
}
