{ config, inputs, ... }:

{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.nixosConfigurations.alien = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../hosts/alien
      config.flake.modules.nixos.workstation
    ];
  };
}
