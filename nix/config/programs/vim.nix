ctx:
let
  theme = "ayu";
  enable = builtins.mapAttrs (k: v: v // { enable = true; });
in
{
  colorschemes.${theme}.enable = true;
  extraPlugins = with ctx.pkgs.vimPlugins; [ Coqtail ];
  opts = {
    autoindent = true;
    autoread = true;
    backspace = [
      "indent"
      "eol"
      "start"
    ];
    # belloff = "all";
    errorbells = false;
    foldenable = false;
    incsearch = true;
    list = true;
    # listchars = [
    #   "tab:>-"
    #   "trail:."
    #   "extends:#"
    #   "nbsp:."
    # ];
    number = true;
    relativenumber = true;
    ruler = true;
    scrolloff = 8;
    shiftround = true;
    shiftwidth = 2;
    showcmd = true;
    showmode = true;
    sidescrolloff = 8;
    smarttab = true;
    softtabstop = 2;
    undolevels = 256;
    wildmenu = true;
    # wildmode = "list:longest";
    wrap = false;
  };
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
