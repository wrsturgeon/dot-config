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
        shellInit = ''
          # Lines configured by zsh-newuser-install
          HISTFILE=~/.zsh_history
          HISTSIZE=2048
          SAVEHIST=2048
          setopt extendedglob notify
          unsetopt autocd beep nomatch
          bindkey -v
          # End of lines configured by zsh-newuser-install
          # The following lines were added by compinstall
          zstyle :compinstall filename '/etc/zshrc'

          autoload -Uz compinit
          compinit
          # End of lines added by compinstall

          echo '#' > ~/.zshrc
        '';
        promptInit = ''
          rm -fr ~/.z*
          echo '#' > ~/.zshrc
          # rm -fr ~/.config/coq
          mkdir -p ~/.config/coq
          # echo 'From Hammer Require Import Tactics.' > ~/.config/coq/coqrc.${ctx.pkgs.coq.version}
          source ${ctx.pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ${"${ctx.dir}/programs/p10k/instant-prompt.zsh"}
          source ${"${ctx.dir}/programs/p10k/config.zsh"}
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
  bash =
    {
      completion.enable = true;
    }
    // ctx.linux-mac { } {
      enable = true;
    };
}
