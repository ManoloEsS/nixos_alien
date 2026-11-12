{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  home.packages = [
    pkgs.wtype
    pkgs.eza
    pkgs.jujutsu
    pkgs.opencode
    pkgs.lazygit
    pkgs.uv
    pkgs.alacritty
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    SYSTEMD_EDITOR = "nvim";
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
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };


  xdg.configFile."ghostty/config".source = ./dotfiles/ghostty/.config/ghostty/config;

  xdg.configFile."alacritty/alacritty.toml".source = ./dotfiles/alacritty/.config/alacritty/alacritty.toml;

  xdg.configFile."herdr/config.toml".source = ./dotfiles/herdr/.config/herdr/config.toml;

  xdg.configFile."tmux/tmux.conf".source = ./dotfiles/tmux/.config/tmux/tmux.conf;

  xdg.configFile."yazi/yazi.toml".source = ./dotfiles/yazi/.config/yazi/yazi.toml;

  xdg.configFile."yazi/theme.toml".source = ./dotfiles/yazi/.config/yazi/theme.toml;
}
