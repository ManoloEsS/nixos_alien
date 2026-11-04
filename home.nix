{ ... }:

{
  home.stateVersion = "26.05";

  programs.noctalia = {
    enable = true;
    settings = ./dotfiles/noctalia/.config/noctalia/config.toml;
  };
}
