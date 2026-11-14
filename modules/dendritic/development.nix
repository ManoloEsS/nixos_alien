{ ... }:

{
  flake.modules.nixos.development = { pkgs, ... }: {
    # A global baseline; project dev shells can select their own toolchains.
    environment.systemPackages = with pkgs; [
      gcc
      gnumake
      python3
      uv
      nodejs
      go
      gotools # Includes goimports, used by Neovim.
      rustc
      cargo
    ];
  };
}
