# E14 preferences observed on its Fedora installation. This module is not a
# complete NixOS host: installation-specific hardware and storage are needed.
{ lib, pkgs, ... }:

{
  imports = [ ./battery.nix ];

  # Avoid the interactive latency spikes observed with Wi-Fi power saving.
  networking.networkmanager.wifi.powersave = false;

  # Confirm this internal keyboard ID on the installed E14 with keyd. External
  # keyboards keep their own mappings.
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [ "0001:0001:09b4e68d" ];
      extraConfig = ''
        [shiftmeta:S-M]

        [main]
        leftcontrol = layer(shiftmeta)
        capslock = overload(control, esc)
        esc = capslock
        leftalt = layer(meta)
        leftmeta = layer(alt)
      '';
    };
  };

  # Keep shared Niri bindings, but launch Ghostty on this host.
  home-manager.users.manoloess.xdg.configFile."niri/config.kdl".source = lib.mkForce (
    pkgs.writeText "niri-thinkpad-e14.kdl" (builtins.replaceStrings
      [ ''spawn "alacritty"'' ]
      [ ''spawn "ghostty"'' ]
      (builtins.readFile ../../../dotfiles/niri/.config/niri/config.kdl))
  );
}
