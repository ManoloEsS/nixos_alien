{
  description = "Manolo's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    import-tree.url = "github:denful/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";
    herdr.url = "github:herdrdev/herdr/v0.9.5";

    nvim-config = {
      url = "github:ManoloEsS/kickstart.nvim/master";
      flake = false;
    };

    yazi-tokyo-night = {
      url = "github:BennyOe/tokyo-night.yazi/8e6296f14daff24151c736ebd0b9b6cd89b02b03";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules/dendritic);
}
