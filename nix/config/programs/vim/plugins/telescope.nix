ctx: {
  keymaps = {
    "<C-p>" = {
      action = "git_files";
      options = {
        desc = "Telescope Git Files";
      };
    };
    "<leader>fb" = "buffers";
    "<leader>fc" = "commands";
    "<leader>ff" = "find_files";
    "<leader>fg" = "live_grep";
    "<leader>fk" = "keymaps";
    "<leader>fm" = "man_pages";
    "<leader>fo" = "vim_options";
    "<leader>fr" = "registers";
    "<leader>ft" = "tags";
    "<leader>gb" = "git_branches";
    "<leader>gc" = "git_bcommits";
    "<leader>gC" = "git_commits";
    "<leader>gcr" = "git_bcommits_range";
    "<leader>gs" = "git_status";
    "<leader>gS" = "git_stash";
    "gd" = "lsp_implementations";
    "gc" = "lsp_incoming_calls";
    "gC" = "lsp_outgoing_calls";
    "gi" = "lsp_implementations";
    "gr" = "lsp_references";
    "gt" = "lsp_implementations";
  };
  extensions = ctx.enable { fzf-native = { }; };
}
