ctx:
let enable = builtins.mapAttrs (k: v: v // { enable = true; });
in {
  colorscheme = ctx.terminal-settings.theme;
  extraPlugins = (with ctx; [ github-dark-nvim ])
    ++ (with ctx.pkgs.vimPlugins; [ Coqtail neovim-ayu ]);
  opts = import ./options.nix;
  plugins = import ./plugins (ctx // { inherit enable; });
}
