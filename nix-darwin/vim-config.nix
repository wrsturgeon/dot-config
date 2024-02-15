pkgs: {
  colorschemes.ayu.enable = true;
  extraPlugins = with pkgs.vimPlugins; [ Coqtail vim-nix ];
  options = {
    expandtab = true;
    number = true;
    shiftwidth = 2;
    tabstop = 2;
  };
  plugins = {
    # airline = {
    #   colorscheme = "ayu";
    #   enable = true;
    # };
    bufferline.enable = true;
  };
}
