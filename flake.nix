{
  description = "Manolo's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";
    herdr.url = "github:herdrdev/herdr/v0.9.5";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nvim-config = {
      url = "github:ManoloEsS/kickstart.nvim/master";
      flake = false;
    };

    yazi-tokyo-night = {
      url = "github:BennyOe/tokyo-night.yazi/8e6296f14daff24151c736ebd0b9b6cd89b02b03";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, herdr, disko, nvim-config, yazi-tokyo-night, ... }: {
    nixosConfigurations.alien = nixpkgs.lib.nixosSystem {
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager

        {
          home-manager.users.manoloess.imports = [
            noctalia.homeModules.default
          ];
          home-manager.users.manoloess.xdg.configFile."yazi/flavors/tokyo-night.yazi".source = yazi-tokyo-night.outPath;
          home-manager.users.manoloess.xdg.configFile."nvim/init.lua".source = "${nvim-config}/init.lua";
          home-manager.users.manoloess.xdg.configFile."nvim/lua".source = "${nvim-config}/lua";
          home-manager.users.manoloess.xdg.configFile."nvim/.stylua.toml".source = "${nvim-config}/.stylua.toml";
          home-manager.users.manoloess.home.packages = [ herdr.packages.x86_64-linux.default ];
        }
      ];
    };

    # Separate installation output: never apply its Disko layout implicitly.
    nixosConfigurations.alien-install = self.nixosConfigurations.alien.extendModules {
      modules = [
        disko.nixosModules.disko
        {
          disabledModules = [ ./hardware-configuration.nix ];
          imports = [ ./modules/hosts/alien/hardware.nix ./modules/hosts/alien/disko.nix ];
        }
      ];
    };
  };
}
