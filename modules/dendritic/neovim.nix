{ inputs, ... }:

{
  flake.modules.nixos.neovim = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    # Project shells can supply language toolchains alongside these tools.
    environment.systemPackages = with pkgs; [
      clang-tools
      gopls
      ruff
      basedpyright
      rust-analyzer
      rustfmt
      lua-language-server
      stylua
      prettier
      prettierd
      markdownlint-cli2
      tree-sitter
    ];

    home-manager.users.manoloess.home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
    };

    home-manager.users.manoloess.xdg.configFile = {
      "nvim/init.lua".source = "${inputs.nvim-config}/init.lua";
      "nvim/lua".source = "${inputs.nvim-config}/lua";
      "nvim/.stylua.toml".source = "${inputs.nvim-config}/.stylua.toml";
    };
  };
}
