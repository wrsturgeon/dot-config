ctx:
let
  theme = "ayu"; # "ghdark";
  enable = builtins.mapAttrs (k: v: v // { enable = true; });
in
{
  colorscheme = theme;
  extraPlugins =
    (with ctx; [ github-dark-nvim ])
    ++ (with ctx.pkgs.vimPlugins; [
      Coqtail
      neovim-ayu
    ]);
  opts = import ./options.nix;
  plugins = import ./plugins (ctx // { inherit enable; });
}
