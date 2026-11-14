{ inputs, ... }:

{
  flake.modules.nixos.neovim = { pkgs, ... }: {
    # Keep the existing tools available while LazyVim support is evaluated.
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

    home-manager.users.manoloess = {
      imports = [ inputs.lazyvim-nix.homeManagerModules.default ];

      programs.neovim = {
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;
      };

      programs.lazyvim = {
        enable = true;
        extras.lang = {
          go = { enable = true; installDependencies = true; };
          python = { enable = true; installDependencies = true; };
          rust = { enable = true; installDependencies = true; };
          nix = { enable = true; installDependencies = true; };
        };
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
        SYSTEMD_EDITOR = "nvim";
      };
    };
  };
}
