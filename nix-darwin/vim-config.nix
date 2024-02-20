pkgs: {

  colorschemes.ayu = {
    enable = true;
    settings.mirage = true; # lighter than ayu-dark
  };

  # unfortunately space comes up a lot while inserting (obviously),
  # and so commands available in insert mode clash quite often with ' '
  globals.mapleader = "\\";

  plugins = {
    airline.enable = true;
    # bufferline.enable = true;
    fugitive.enable = true;
    nix.enable = true;
    rust-tools.enable = true;
    telescope.enable = true;
    treesitter.enable = true;
    undotree.enable = true;
  };
  extraPlugins = with pkgs.vimPlugins; [ Coqtail vim-dispatch vim-nix ];

  options = {
    expandtab = true;
    number = true;
    shiftwidth = 2;
    tabstop = 2;
  };

  keymaps = [

    # dispatch
    {
      mode = "n";
      key = "<leader>m";
      # options.silent = true;
      action = "<cmd>Make<cr>";
    }

    # telescope
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
    }
    {
      mode = "n";
      key = "<leader>rg"; # for `ripgrep`
      action = "<cmd>Telescope live_grep<cr>";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope find_buffers<cr>";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<cr>";
    }

    # fugitive
    {
      mode = "n";
      key = "<leader>ga";
      action = "<cmd>Git add .<cr>";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Git blame<cr>";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Git commit<cr>";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>Git diff<cr>";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>Git log<cr>";
    }
    {
      mode = "n";
      key = "<leader>gm";
      # action = "<cmd>Git merge origin/main<cr>";
      action = "<cmd>Git mergetool<cr>";
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>Git pull<cr>";
    }
    {
      mode = "n";
      key = "<leader>gs"; # for `git status`
      action = "<cmd>Git status<cr>";
    }
  ];
}
