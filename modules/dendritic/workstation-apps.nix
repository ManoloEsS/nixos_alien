{ inputs, ... }:

{
  flake.modules.nixos.workstation-apps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ brave brave-origin ghostty yazi ];

    home-manager.users.manoloess = {
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

      xdg.configFile."ghostty/config".source = ../../dotfiles/ghostty/.config/ghostty/config;
      xdg.configFile."alacritty/alacritty.toml".source = ../../dotfiles/alacritty/.config/alacritty/alacritty.toml;
      xdg.configFile."herdr/config.toml".source = ../../dotfiles/herdr/.config/herdr/config.toml;
      xdg.configFile."yazi/yazi.toml".source = ../../dotfiles/yazi/.config/yazi/yazi.toml;
      xdg.configFile."yazi/theme.toml".source = ../../dotfiles/yazi/.config/yazi/theme.toml;
      xdg.configFile."yazi/flavors/tokyo-night.yazi".source = inputs.yazi-tokyo-night.outPath;
      home.packages = [ pkgs.alacritty inputs.herdr.packages.x86_64-linux.default ];
    };
  };
}
