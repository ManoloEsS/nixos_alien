{ ... }:

{
  services.keyd = {
    enable = true;

    keyboards.internal = {
      ids = [ "0001:0001:3ca03456" ];

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
