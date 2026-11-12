{ ... }:

{
  flake.modules.nixos.development = { pkgs, ... }: {
    # A global baseline; project dev shells can select their own toolchains.
    environment.systemPackages = with pkgs; [
      rustc
      cargo
    ];
  };
}
