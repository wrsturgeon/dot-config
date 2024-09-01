ctx:
let
  theme = "ghdark"; # "ayu";
  enable = builtins.mapAttrs (k: v: v // { enable = true; });
in
{
  # colorschemes.${theme}.enable = true;
  colorscheme = theme;
  extraPlugins =
    (with ctx; [ github-dark-nvim ])
    ++ (with ctx.pkgs.vimPlugins; [ (builtins.trace "${Coqtail}" Coqtail) ]);
  opts = import ./options.nix;
  plugins = import ./plugins (ctx // { inherit enable; });
}
