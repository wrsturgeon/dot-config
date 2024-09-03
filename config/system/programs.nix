ctx:
builtins.mapAttrs ((k: v: v // { enable = true; }) ({
  direnv = {
    direnvrcExtra = "echo 'Loaded direnv'";
    nix-direnv.enable = true;
  };
  zsh = {
    enableBashCompletion = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    promptInit =
      "source ${ctx.pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  } // ctx.linux-mac { } {
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
  };
} // ctx.linux-mac { } {
  dconf = { };
  mtr = { };
  pantheon-tweaks = { };
  tmux = {
    enableFzf = true;
    enableMouse = true;
    enableSensible = true;
    enableVim = true;
  };
})) // {
  bash = { enableCompletion = true; } // linux-mac { } { enable = true; };
}
