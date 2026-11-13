# ALIEN ONLY: after reinstall, review the generated hardware file, bootloader,
# and internal keyboard ID in ./keyd.nix before building or switching.
{ lib, pkgs, ... }:

{
  imports = [
    ../../../hardware-configuration.nix
    ./keyd.nix
  ];

  networking.hostName = "alien";

  # Alien is the test host and keeps Alacritty instead of the shared Ghostty.
  home-manager.users.manoloess.xdg.configFile."niri/config.kdl".source = lib.mkForce (
    let
      shared = builtins.readFile ../../../dotfiles/niri/.config/niri/config.kdl;
      binding = ''Mod+Return hotkey-overlay-title="Open a terminal" { spawn "ghostty"; }'';
    in
    assert lib.hasInfix binding shared;
    pkgs.writeText "niri-alien.kdl" (builtins.replaceStrings
      [ binding ]
      [ ''Mod+Return hotkey-overlay-title="Open a terminal" { spawn "alacritty"; }'' ]
      shared)
  );


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
