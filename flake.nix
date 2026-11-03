{
  description = "Manolo's NixOS configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.alien = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
