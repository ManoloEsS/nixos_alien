{ ... }:

{
  flake.modules.nixos.shell = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.tmux ];

    home-manager.users.manoloess = {
      xdg.configFile."tmux/tmux.conf".source = ../../dotfiles/tmux/.config/tmux/tmux.conf;
      programs.bash.enable = true;
      home.file.".bash_aliases".source = ../../dotfiles/bash/.bash_aliases;
      home.file.".bash_functions".source = ../../dotfiles/bash/.bash_functions;
      home.file.".inputrc".source = ../../dotfiles/bash/.inputrc;

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
      xdg.configFile."starship.toml".source = ../../dotfiles/starship/.config/starship.toml;

      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
      };

      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
