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
    belloff = "all";
    cursorline = true;
    cursorlineopt = "line";
    errorbells = false;
    expandtab = true;
    foldenable = false;
    hlsearch = false;
    ignorecase = true;
    incsearch = true;
    list = true;
    listchars = "tab:> ,trail:-,extends:#,nbsp:+";
    mouse = "";
    number = true;
    relativenumber = true;
    ruler = true;
    scrolloff = 8;
    shiftround = true;
    shiftwidth = 2;
    showcmd = true;
    showmode = true;
    sidescrolloff = 8;
    signcolumn = "yes";
    smarttab = true;
    splitbelow = true;
    splitright = true;
    softtabstop = 2;
    tabstop = 2;
    termguicolors = true;
    undolevels = 256;
    wildmenu = true;
    wildmode = "list:longest";
    wrap = false;
  };
  plugins = enable {
    gitsigns = {
      gitPackage = ctx.git;
    };
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
