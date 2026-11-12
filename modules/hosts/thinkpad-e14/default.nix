# E14 preferences observed on its Fedora installation. This module is not a
# complete NixOS host: installation-specific hardware and storage are needed.
{ ... }:

{
  # Avoid the interactive latency spikes observed with Wi-Fi power saving.
  networking.networkmanager.wifi.powersave = false;

  # Match the current E14 behavior: apply the remapping to every keyboard.
  services.keyd = {
    enable = true;
    keyboards.all = {
      ids = [ "*" ];
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
