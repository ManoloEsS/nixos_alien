# Installation design only: not imported into the running alien configuration.
# Applying this layout destroys the selected disk. Verify the device first.
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-Lexar_SSD_NS100_256GB_PLK955W1007840S321";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "fmask=0077" "dmask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "alien-root";
            # No key file: Disko prompts interactively when formatting.
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
