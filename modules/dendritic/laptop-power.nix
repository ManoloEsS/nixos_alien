{ ... }:

{
  flake.modules.nixos.laptop-power = { ... }: {
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    # Compressed RAM-backed swap for memory pressure, not hibernation.
    zramSwap.enable = true;
  };
}
