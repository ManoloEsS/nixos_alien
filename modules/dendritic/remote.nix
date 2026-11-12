{ config, inputs, ... }:

{
  flake.nixosConfigurations.remote = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../hosts/remote
      config.flake.modules.nixos.thinkpad-e14
    ];
  };
}
