{ ... }:

{
  flake.modules.nixos.docker = { pkgs, ... }: {
    virtualisation.docker.enable = true;
    environment.systemPackages = [ pkgs.docker-compose ];

    # Deliberately do not add the user to the docker group: use sudo.
  };
}
