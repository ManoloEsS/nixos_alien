{ inputs, ... }:

{
  flake.modules.nixos.neovim = { lib, pkgs, ... }: {
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

    home-manager.users.manoloess = {
      imports = [ inputs.lazyvim-nix.homeManagerModules.default ];

      programs.lazyvim = {
        enable = true;
        extraPackages = [ pkgs.golangci-lint ];
        # Avoid the Trouble symbols statusline error; keep Trouble available.
        config.options = ''
          vim.g.trouble_lualine = false
        '';
        extras = {
          coding.blink.enable = true;
          editor.snacks-picker.enable = true;
          formatting.prettier = { enable = true; installDependencies = true; };
          lang.go = { enable = true; installDependencies = true; };
          lang.python = { enable = true; installDependencies = true; };
          lang.rust = { enable = true; installDependencies = true; };
          lang.typescript = { enable = true; installDependencies = true; };
          ui.smear-cursor.enable = true;
        };
        # Custom overlay plugin specs are linked separately; give lazy.nvim
        # explicit Nix-store paths instead of relying on runtime downloads.
        plugins.custom-sources = ''
          return {
            { "ThePrimeagen/harpoon", dir = "${pkgs.vimPlugins.harpoon2}" },
            { "chentoast/marks.nvim", dir = "${pkgs.vimPlugins.marks-nvim}" },
            { "karb94/neoscroll.nvim", dir = "${pkgs.vimPlugins.neoscroll-nvim}" },
            { "nvim-orgmode/orgmode", dir = "${pkgs.vimPlugins.orgmode}" },
            { "nvim-orgmode/org-bullets.nvim", dir = "${inputs.org-bullets}" },
            { "mikavilpas/yazi.nvim", dir = "${pkgs.vimPlugins.yazi-nvim}" },
          }
        '';
      };

      xdg.configFile = lib.genAttrs (map (name: "nvim/lua/plugins/${name}.lua") [
        "blink" "harpoon" "hide-bufferline" "language-formatting"
        "lazyvim-custom" "marks" "neo-tree" "neoscroll" "orgmode"
        "smear-cursor" "yazi"
      ]) (path: {
        source = "${inputs.lazyvim-custom}/nvim/.config/${path}";
      }) // {
        "nvim/plugin/after/transparency.lua".source =
          "${inputs.lazyvim-custom}/nvim/.config/nvim/plugin/after/transparency.lua";
      };
    };
  };
}
