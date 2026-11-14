{ inputs, ... }:

{
  flake.modules.nixos.workstation-apps = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ghostty pkgs.yazi ];

    home-manager.users.manoloess = {
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
