{
  description = "Manolo's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";

    yazi-tokyo-night = {
      url = "github:BennyOe/tokyo-night.yazi/8e6296f14daff24151c736ebd0b9b6cd89b02b03";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, noctalia, ... }: {
    nixosConfigurations.alien = nixpkgs.lib.nixosSystem {
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager

        {
          home-manager.users.manoloess.imports = [
            noctalia.homeModules.default
          ];
        }
      ];
    };
  };
}
