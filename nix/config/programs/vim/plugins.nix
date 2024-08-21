ctx:
ctx.enable {
  gitsigns = {
    gitPackage = ctx.git;
  };
  lsp = {
    servers = ctx.enable {
      bashls = { };
      clangd = { };
      hls = { };
      nixd = { };
      ocamllsp = { };
      ruff = { };
      rust-analyzer = {
        installCargo = true;
        cargoPackage = ctx.pkgs.cargo;
        installRustc = true;
        rustcPackage = ctx.pkgs.rustc;
      };
    };
    keymaps.lspBuf = {
      "gd" = "definition";
      "gD" = "references";
      "gt" = "type_definition";
      "gi" = "implementation";
      "K" = "hover";
    };
  };
  lsp-format = { };
  lualine = { };
  rainbow-delimiters = { };
  # rust-tools = { };
  telescope = {
    keymaps = {
      "<leader>fg" = "live_grep";
      "<C-p>" = {
        action = "git_files";
        options = {
          desc = "Telescope Git Files";
        };
      };
    };
    extensions = ctx.enable { fzf-native = { }; };
  };
  treesitter = {
    nixGrammars = true;
    settings.indent.enable = true;
  };
  treesitter-context.settings.maxLines = 2;
}
