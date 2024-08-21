ctx:
let
  theme = "ayu";
  enable = builtins.mapAttrs (k: v: v // { enable = true; });
in
{
  colorschemes.${theme}.enable = true;
  extraPlugins = with ctx.pkgs.vimPlugins; [ Coqtail ];
  opts = import ./options.nix;
  plugins = import ./plugins.nix (ctx // { inherit enable; });
}
