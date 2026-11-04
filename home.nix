{ pkgs, ... }:

{
  home.stateVersion = "26.05";

    home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  programs.noctalia = {
    enable = true;
    settings = ./dotfiles/noctalia/.config/noctalia/config.toml;
  };

  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/.config/niri/config.kdl;
}
