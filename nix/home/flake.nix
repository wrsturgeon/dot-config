{
  description = "Home Manager config";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { home-manager, nixpkgs, self }: {
    configure =
      { linux-mac, nixpkgs-config, shared, stateVersion, system, username }:
      let
        pkgs = import nixpkgs nixpkgs-config;
        user-cfg = {
          home = {
            inherit stateVersion username;
            packages = with pkgs; [ cachix ];
          };
          programs = {
            git.enable = true;
            gpg.enable = true;
            helix.enable = true;
            home-manager.enable = true;
            kitty = {
              enable = true;
              settings = {
                font_family = "IBM Plex Mono Light";
                bold_font = "IBM Plex Mono Bold";
                italic_font = "IBM Plex Mono Light Italic";
                bold_italic_font = "IBM Plex Mono Bold Italic";
                font_size = linux-mac 9 11;
              };
              shellIntegration.enableZshIntegration = true;
              theme = "Ayu";
            };
            ripgrep.enable = true;
            vim = {
              enable = true;
              extraConfig = builtins.readFile ./vimrc;
              plugins = with pkgs.vimPlugins; [
                ale
                ayu-vim
                Coqtail
                fugitive
                fzf-vim
                gitgutter
                nil
                nixfmt
                python3
                vim-airline
                vim-nix
              ];
              settings = {
                background = "dark";
                copyindent = true;
                expandtab = true;
                hidden = true;
                history = 1000;
                ignorecase = false;
                modeline = false;
                mouse = "a";
                number = true;
                relativenumber = false;
                shiftwidth = 2;
                smartcase = true;
                tabstop = 2;
              };
            };
            zsh = {
              enable = true;
              enableAutosuggestions = true;
              enableCompletion = true;
              initExtra = ''
                # p10k
                source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
                # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
                # Initialization code that may require console input (password prompts, [y/n]
                # confirmations, etc.) must go above this block; everything else may go below.
                if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                  source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
                fi
                source ${./p10k.zsh}

                # direnv
                eval "$(direnv hook zsh)"
              '';
              syntaxHighlighting = {
                enable = true;
                styles = {
                  # TODO: <https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.syntaxHighlighting.styles>
                };
              };
            };
          };
        } // (linux-mac {
          xsession.enable = true;
          # xsession.windowManager.command = "...";
        } { });
      in [
        home-manager.${linux-mac "nixosModules" "darwinModules"}.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = user-cfg;
          };
        }
      ];
  };
}
