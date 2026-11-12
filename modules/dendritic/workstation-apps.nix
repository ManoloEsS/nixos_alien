{ inputs, ... }:

{
  flake.modules.nixos.workstation-apps = { ... }: {
    home-manager.users.manoloess = {
      xdg.configFile."yazi/flavors/tokyo-night.yazi".source = inputs.yazi-tokyo-night.outPath;
      home.packages = [ inputs.herdr.packages.x86_64-linux.default ];
    };
  };
}
