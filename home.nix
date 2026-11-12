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

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./dotfiles/starship/.config/starship.toml;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
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

  xdg.configFile."alacritty/alacritty.toml".source = ./dotfiles/alacritty/.config/alacritty/alacritty.toml;

  xdg.configFile."herdr/config.toml".source = ./dotfiles/herdr/.config/herdr/config.toml;

  xdg.configFile."tmux/tmux.conf".source = ./dotfiles/tmux/.config/tmux/tmux.conf;

  xdg.configFile."yazi/yazi.toml".source = ./dotfiles/yazi/.config/yazi/yazi.toml;

  xdg.configFile."yazi/theme.toml".source = ./dotfiles/yazi/.config/yazi/theme.toml;
}
