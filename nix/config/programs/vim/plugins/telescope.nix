ctx: {
  keymaps = {
    "<leader>fg" = "live_grep";
    "<C-p>" = {
      action = "git_files";
      options = {
        desc = "Telescope Git Files";
      };
    };
  };
  extensions = ctx.enable { fzf-native = { }; };
}
