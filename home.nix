{ pkgs, ... }:

{
  home.packages = [
    pkgs.wtype
    pkgs.eza
    pkgs.opencode
    pkgs.lazygit
  ];

  home.sessionVariables = {
    BAT_THEME = "ansi";
    MANROFFOPT = "-c";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  # Utilities script sourcing
  home.file.".local/bin/universal-clipboard".source = ./dotfiles/utilities/universal-clipboard;
  home.file.".local/bin/toggle-touchpad".source = ./dotfiles/utilities/toggle-touchpad;

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "brave-origin.desktop";
      "x-scheme-handler/http" = "brave-origin.desktop";
      "x-scheme-handler/https" = "brave-origin.desktop";
      "x-scheme-handler/about" = "brave-origin.desktop";
      "x-scheme-handler/unknown" = "brave-origin.desktop";
    };
  };


}
