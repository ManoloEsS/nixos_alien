# E14-specific preferences for the remote host.
{ ... }:

{
  imports = [ ./battery.nix ];

  # Avoid the interactive latency spikes observed with Wi-Fi power saving.
  networking.networkmanager.wifi.powersave = false;

  # Confirm this internal keyboard ID on the installed E14 with keyd. External
  # keyboards keep their own mappings.
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [ "0001:0001:09b4e68d" ];
      extraConfig = ''
        [shiftmeta:S-M]

        [main]
        leftcontrol = layer(shiftmeta)
        capslock = overload(control, esc)
        esc = capslock
        leftalt = layer(meta)
        leftmeta = layer(alt)
      '';
    };
  };

}
