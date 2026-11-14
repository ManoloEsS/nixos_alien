{ ... }:

{
  flake.modules.nixos.version-control = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      gh
    ];

    home-manager.users.manoloess = {
      home.packages = [ pkgs.lazygit ];

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
