{ ... }:

{
  flake.modules.nixos.networking = { ... }: {
    networking.networkmanager.enable = true;
    networking.nftables.enable = true;

    # Trusted connection zones are assigned separately in NetworkManager.
    services.firewalld = {
      enable = true;
      settings.DefaultZone = "drop";
    };

    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--ssh" ];
    };

    services.openssh.enable = true;
  };
}
