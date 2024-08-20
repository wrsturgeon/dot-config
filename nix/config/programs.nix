ctx: {
  bash = {
    enable = true;
    enableCompletion = true;
  };
  direnv = {
    enable = true;
    direnvrcExtra = "echo 'Loaded direnv'";
    nix-direnv.enable = true;
  };
  emacs = {
    enable = true;
  };
  tmux = {
    enable = true;
    enableFzf = true;
    enableMouse = true;
    enableSensible = true;
    enableVim = true;
  };
  zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
  };
}
