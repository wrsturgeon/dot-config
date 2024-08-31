ctx:
let
  theme = "github-dark"; # "ayu";
  enable = builtins.mapAttrs (k: v: v // { enable = true; });
in
{
  colorschemes.${theme}.enable = true;
  extraPlugins = with ctx.pkgs.vimPlugins; [ Coqtail ];
  opts = import ./options.nix;
  plugins = import ./plugins (ctx // { inherit enable; });
}
