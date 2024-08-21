ctx:
let
  theme = "ayu";
  enable = builtins.mapAttrs (k: v: v // { enable = true; });
in
{
  colorschemes.${theme}.enable = true;
  plugins = enable {
    lsp = {
      servers = enable {
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
    rainbow-delimiters = { };
    # rust-tools = { };
    treesitter = {
      nixGrammars = true;
      settings.indent.enable = true;
    };
    treesitter-context.settings.maxLines = 2;
  };
}
