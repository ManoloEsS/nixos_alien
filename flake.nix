{
  description = "Manolo's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.alien = nixpkgs.lib.nixosSystem {
      modules = [ 
        ./configuration.nix 
	home-manager.nixosModules.home-manager
      ];
    };
  };
}
