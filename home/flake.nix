{
  description = "Home Manager config";
  inputs = {
    firefox-addons = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    jupyter-vim-src = {
      flake = false;
      url = "github:jupyter-vim/jupyter-vim";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { firefox-addons, home-manager, jupyter-vim-src, nixpkgs, self }: {
    configure = { home, laptop-name, linux-mac, nixpkgs-config, stateVersion
      , system, username }:
      let
        pkgs = import nixpkgs nixpkgs-config;
        user-cfg = {
          home = {
            inherit stateVersion username;
            packages = (with pkgs; [
              cachix
              cargo
              coqPackages.coq
              discord
              fd
              gcc
              gnumake
              logseq
              nil
              nix-direnv
              nixfmt
              pinentry
              rust-analyzer
              rustfmt
              slack
              spotify
              taplo
              # wezterm
              zoom-us
            ]);
          };
          programs = {
            direnv = {
              enable = true;
              enableZshIntegration = true;
              nix-direnv.enable = true;
            };
            emacs = {
              enable = true;
              package = pkgs.emacs;
            };
            fzf = {
              enable = true;
              enableZshIntegration = true;
            };
            gh = {
              enable = true;
              settings = {
                # Aliases allow you to create nicknames for gh commands
                aliases = { co = "pr checkout"; };
                # What editor gh should run when creating issues, pull requests, etc. If blank, will refer to environment.
                editor = "";
                # The current version of the config schema
                version = 1;
                # What protocol to use when performing git operations. Supported values: ssh, https
                git_protocol = "https";
              };
            };
            git.enable = true;
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
            neovim = {
              enable = true;
              extraLuaConfig = builtins.readFile ./init.lua;
              plugins = with pkgs.vimPlugins; [ neovim-ayu ];
              viAlias = true;
              vimAlias = true;
              vimdiffAlias = true;
              withPython3 = true;
            };
            ripgrep.enable = true;
            # vim = {
            #   enable = true;
            #   extraConfig = builtins.readFile ./vimrc;
            #   plugins = let
            #     jupyter-vim = pkgs.vimUtils.buildVimPlugin {
            #       name = "jupyter-vim";
            #       src = jupyter-vim-src;
            #     };
            #   in (with pkgs.vimPlugins; [
            #     Coqtail
            #     fugitive
            #     fzf-vim
            #     gitgutter
            #     vim-airline
            #     vim-lsp
            #     vim-nix
            #   ]) ++ [ jupyter-vim ];
            #   # package =
            #   #   pkgs.vim_configurable.override { python = pkgs.python3; };
            #   settings = {
            #     background = "dark";
            #     copyindent = true;
            #     expandtab = true;
            #     hidden = true;
            #     history = 1000;
            #     ignorecase = false;
            #     modeline = false;
            #     mouse = null;
            #     number = true;
            #     relativenumber = false;
            #     shiftwidth = 4;
            #     smartcase = true;
            #     tabstop = 4;
            #   };
            # };
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
          } // (linux-mac {
            firefox = {
              enable = true;
              profiles.will = {
                # bookmarks directly from <https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.bookmarks>:
                bookmarks = [
                  {
                    name = "wikipedia";
                    tags = [ "wiki" ];
                    keyword = "wiki";
                    url =
                      "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
                  }
                  {
                    name = "kernel.org";
                    url = "https://www.kernel.org";
                  }
                  {
                    name = "Nix sites";
                    toolbar = true;
                    bookmarks = [
                      {
                        name = "homepage";
                        url = "https://nixos.org/";
                      }
                      {
                        name = "wiki";
                        tags = [ "wiki" "nix" ];
                        url = "https://nixos.wiki/";
                      }
                    ];
                  }
                ];
                extensions = with firefox-addons.packages.${system};
                  [ ublock-origin ];
              };
            };
          } { });
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
