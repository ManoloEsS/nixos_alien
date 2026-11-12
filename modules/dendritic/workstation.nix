{ config, ... }:

{
  flake.modules.nixos.workstation = { ... }: {
    imports = [
      ../../configuration.nix
      config.flake.modules.nixos.neovim
      config.flake.modules.nixos.shell
      config.flake.modules.nixos.desktop
      config.flake.modules.nixos.networking
      config.flake.modules.nixos.laptop-power
      config.flake.modules.nixos.audio-bluetooth
      config.flake.modules.nixos.user
      config.flake.modules.nixos.workstation-apps
      config.flake.modules.nixos.version-control
    ];
  };
}
