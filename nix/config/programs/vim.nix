let
  theme = "ayu";
in
{
  colorschemes.${theme}.enable = true;
  plugins = builtins.mapAttrs (k: v: v // { enable = true; }) {
    lsp = {
      servers = builtins.mapAttrs (k: v: v // { enable = true; }) {
        bashls = { };
        clangd = { };
        hls = { };
        nixd = { };
        ocamllsp = { };
        ruff = { };
        rust-analyzer = {
          installRustc = true;
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
    rainbow-delimiters = { };
    # rust-tools = { };
    treesitter = {
      nixGrammars = true;
      settings.indent.enable = true;
    };
    treesitter-context.settings.maxLines = 2;
  };
}
