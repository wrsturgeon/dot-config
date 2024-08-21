let
  theme = "ayu";
in
{
  colorschemes.${theme}.enable = true;
  plugins = builtins.mapAttrs (k: v: v // { enable = true; }) {
    lsp = {
      servers = {
        bashls.enable = true;
        clangd.enable = true;
        hls.enable = true;
        nixd.enable = true;
        ocamllsp = true;
        ruff = true;
        rust-analyzer = true;
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
