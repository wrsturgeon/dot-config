ctx:
(builtins.mapAttrs (_: v: v // { enable = true; }) (
  {
    direnv = {
      direnvrcExtra = "echo 'Loaded direnv'";
      nix-direnv.enable = true;
    };
    zsh =
      {
        enableBashCompletion = true;
        enableCompletion = true;
        promptInit = ''
          # source ${ctx.pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ${config/programs/p10k/instant-prompt.zsh}
          source ${config/programs/p10k/config.zsh}
        '';
      }
      // ctx.linux-mac { syntaxHighlighting.enable = true; } {
        enableFzfCompletion = true;
        enableFzfGit = true;
        enableFzfHistory = true;
        enableSyntaxHighlighting = true;
      };
  }
  //
    ctx.linux-mac
      {
        dconf = { };
        mtr = { };
      }
      {
        tmux = {
          enableFzf = true;
          enableMouse = true;
          enableSensible = true;
          enableVim = true;
        };
      }
))
// {
  bash = ctx.linux-mac { completion.enable = true; } {
    enable = true;
    enableCompletion = true;
  };
}
