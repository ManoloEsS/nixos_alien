{ inputs, ... }:

{
  flake.modules.nixos.desktop = { lib, pkgs, ... }: {
    # Noctalia's official cache can avoid compiling its flake package locally.
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.gnome.core-apps.enable = false;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

    programs.niri.enable = true;
    services.displayManager.defaultSession = "niri";

    home-manager.users.manoloess = {
      home.pointerCursor = {
        enable = true;
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
      };

      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        settings = ../../dotfiles/noctalia/.config/noctalia/config.toml;
      };

      xdg.configFile."niri/config.kdl".source = ../../dotfiles/niri/.config/niri/config.kdl;
      xdg.configFile."niri/terminal.kdl".text = lib.mkDefault ''
        binds {
            Mod+Return hotkey-overlay-title="Open a terminal" { spawn "ghostty"; }
        }
      '';
    };
  };
}
