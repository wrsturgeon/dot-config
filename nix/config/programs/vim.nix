let
  theme = "ayu";
in
{
  colorschemes.${theme}.enable = true;
  plugins = builtins.mapAttrs (k: v: v // { enable = true; }) {
    rainbow-delimiters = { };
    treesitter = {
      nixGrammars = true;
      settings.indent.enable = true;
    };
    treesitter-context.settings.maxLines = 2;
  };
}
