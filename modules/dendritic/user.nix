{ inputs, ... }:

{
  flake.modules.nixos.user = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    users.users.manoloess = {
      isNormalUser = true;
      description = "ManoloEsS";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = [ ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.manoloess = import ../../home.nix;
      # Rename conflicting existing files instead of overwriting them.
      backupFileExtension = "hm-backup";
    };
  };
}
