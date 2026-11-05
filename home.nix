{ pkgs, ... }:

{
  home.stateVersion = "26.05";

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  home.packages = [
    pkgs.wtype
  ];

  # Utilities script sourcing
  home.file.".local/bin/universal-clipboard".source = ./dotfiles/utilities/universal-clipboard;
  home.file.".local/bin/toggle-touchpad".source = ./dotfiles/utilities/toggle-touchpad;

  # Bash configuration
  programs.bash.enable = true;
  home.file.".bash_aliases".source = ./dotfiles/bash/.bash_aliases;
  home.file.".bash_functions".source = ./dotfiles/bash/.bash_functions;
  home.file.".inputrc".source = ./dotfiles/bash/.inputrc;

  programs.bash.initExtra = ''
    source "$HOME/.bash_aliases"
    source "$HOME/.bash_functions"
  '';

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  

  # Noctalia config
  programs.noctalia = {
    enable = true;
    settings = ./dotfiles/noctalia/.config/noctalia/config.toml;
  };

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


  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/.config/niri/config.kdl;

  xdg.configFile."ghostty/config".source = ./dotfiles/ghostty/.config/ghostty/config;

  xdg.configFile."tmux/tmux.conf".source = ./dotfiles/tmux/.config/tmux/tmux.conf;

  xdg.configFile."yazi/yazi.toml".source = ./dotfiles/yazi/.config/yazi/yazi.toml;

  xdg.configFile."yazi/theme.toml".source = ./dotfiles/yazi/.config/yazi/theme.toml;
}
