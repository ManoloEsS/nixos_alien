{ pkgs, ... }:

{
  home.packages = [
    pkgs.wtype
    pkgs.eza
    pkgs.opencode
  ];

  # Utilities script sourcing
  home.file.".local/bin/universal-clipboard".source = ./dotfiles/utilities/universal-clipboard;
  home.file.".local/bin/toggle-touchpad".source = ./dotfiles/utilities/toggle-touchpad;

}
