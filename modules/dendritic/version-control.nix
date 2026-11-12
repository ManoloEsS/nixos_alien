{ ... }:

{
  flake.modules.nixos.version-control = { ... }: {
    home-manager.users.manoloess = {
      programs.git = {
        enable = true;
        settings.user = {
          name = "ManoloEsS";
          email = "manolo.estrada.s@gmail.com";
        };
      };

      programs.jujutsu = {
        enable = true;
        settings.user = {
          name = "ManoloEsS";
          email = "manolo.estrada.s@gmail.com";
        };
      };
    };
  };
}
