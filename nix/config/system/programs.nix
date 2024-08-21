ctx:
builtins.mapAttrs (k: v: v // { enable = true; }) {
  bash = {
    enableCompletion = true;
  };
  direnv = {
    direnvrcExtra = "echo 'Loaded direnv'";
    nix-direnv.enable = true;
  };
  tmux = {
    enableFzf = true;
    enableMouse = true;
    enableSensible = true;
    enableVim = true;
  };
  zsh = {
    enableBashCompletion = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
  };
}
