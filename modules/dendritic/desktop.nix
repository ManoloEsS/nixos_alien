{ inputs, ... }:

{
  flake.modules.nixos.desktop = { ... }: {
    programs.niri.enable = true;

    home-manager.users.manoloess = {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        settings = ../../dotfiles/noctalia/.config/noctalia/config.toml;
      };

      xdg.configFile."niri/config.kdl".source = ../../dotfiles/niri/.config/niri/config.kdl;
    };
  };
}
