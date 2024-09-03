ctx:
builtins.mapAttrs (k: v: v // { enable = true; }) {
  bash = { enableCompletion = true; };
  direnv = {
    direnvrcExtra = "echo 'Loaded direnv'";
    nix-direnv.enable = true;
  };
  tmux = {
    enableMouse = true;
    enableSensible = true;
    enableVim = true;
  } // ctx.linux-mac { } { enableFzf = true; };
  zsh = {
    enableBashCompletion = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    promptInit =
      "source ${ctx.pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };
}
