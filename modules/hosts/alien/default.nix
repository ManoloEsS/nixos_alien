{ pkgs, ... }:

{
  imports = [
    ../../../hardware-configuration.nix
    ./keyd.nix
  ];

  networking.hostName = "alien";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # Keep the initial installation version for data compatibility.
  system.stateVersion = "26.05";
  home-manager.users.manoloess.home.stateVersion = "26.05";
}
