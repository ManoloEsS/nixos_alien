# ALIEN ONLY: after reinstall, review the generated hardware file, bootloader,
# and internal keyboard ID in ./keyd.nix before building or switching.
{ pkgs, ... }:

{
  imports = [
    ../../../hardware-configuration.nix
    ./keyd.nix
  ];

  networking.hostName = "alien";


  # Confirm the new installation uses UEFI/systemd-boot before keeping these.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # Keep these installation state versions for data compatibility; do not
  # bump them as an upgrade. For a fresh install, review the installer's values.
  system.stateVersion = "26.05";
  home-manager.users.manoloess.home.stateVersion = "26.05";

  # Uncomment to enable automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "manoloess";
}
