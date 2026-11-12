{ config, ... }:

{
  # This composition needs installation-specific hardware, boot, hostname,
  # and state versions before it can become a NixOS configuration output.
  flake.modules.nixos.thinkpad-e14 = { ... }: {
    imports = [
      config.flake.modules.nixos.workstation
      ../hosts/thinkpad-e14
    ];
  };
}
