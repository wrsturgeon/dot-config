{
  description = "Home Manager config";
  inputs = {
    apple-fonts = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lyndeno/apple-fonts.nix";
    };
    firefox-addons = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hydrogen-textobjects-src = {
      flake = false;
      url = "github:gcballesteros/vim-textobj-hydrogen";
    };
    jupytext-src = {
      flake = false;
      url = "github:gcballesteros/jupytext.nvim";
    };
    nil = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:oxalica/nil";
    };
    nixfmt = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:serokell/nixfmt";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sf-mono-liga-src = {
      flake = false;
      url = "github:shaunsingh/sfmono-nerd-font-ligaturized";
    };
  };
  outputs = { apple-fonts, firefox-addons, home-manager
    , hydrogen-textobjects-src, jupytext-src, nil, nixfmt, nixpkgs, self
    , sf-mono-liga-src }: {
      configure = { home, laptop-name, linux-mac, nixpkgs-config, stateVersion
        , system, username }:
        let
          pkgs = import nixpkgs nixpkgs-config;
          jupytext = pkgs.vimUtils.buildVimPlugin {
            name = "jupytext";
            src = jupytext-src;
          };
          hydrogen-textobjects = pkgs.vimUtils.buildVimPlugin {
            name = "hydrogen-textobjects";
            src = hydrogen-textobjects-src;
          };
          print-list = builtins.foldl' (acc: s: acc + " " + s) "";
          apple-font-packages = apple-fonts.packages.${system};
          apple-font-names = builtins.attrNames apple-font-packages;
          nerdless-apple-font-names =
            builtins.filter (s: !(pkgs.lib.strings.hasSuffix "nerd" s))
            apple-font-names;
          nerdless-apple-fonts = map (s: apple-font-packages.${s})
            (builtins.trace
              "Apple fonts:${print-list nerdless-apple-font-names}"
              nerdless-apple-font-names);
          input-fonts = pkgs.input-fonts.override { acceptLicense = true; };
          iosevka-name = "Iosevka Custom";
          iosevka = pkgs.iosevka.override {
            # <https://github.com/be5invis/Iosevka/blob/main/doc/language-specific-ligation-sets.md>
            privateBuildPlan = {
              exportGlyphNames = true;
              family = iosevka-name;
              # <https://github.com/be5invis/Iosevka?tab=readme-ov-file#ligations>
              ligatures = {
                # enable all those not enabled by `dlig` below
                # (see the above link for a visual depiction of which):
                enables = [ "eqexeq" "eqslasheq" "slasheq" "tildeeq" ];
                inherits = "dlig";
              };
              spacing = "fontconfig-mono";
              webfontFormats = [ ]; # i.e. none
            };
            set = "custom";
          };
          sf-mono-liga = pkgs.stdenvNoCC.mkDerivation {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };
          font-packages = nerdless-apple-fonts
            ++ [ input-fonts iosevka sf-mono-liga ]
            ++ (with pkgs; [ cascadia-code ibm-plex ]);
          user-cfg = {
            fonts.fontconfig.enable = true;
            home = {
              inherit stateVersion username;
              packages =
                (builtins.map (f: f.packages.${system}.default) [ nil nixfmt ])
                ++ font-packages ++ (with pkgs;
                  ([
                    cargo
                    coqPackages.coq
                    discord
                    fd
                    gcc
                    gnumake
                    logseq
                    pinentry
                    rust-analyzer
                    rustfmt
                    slack
                    spotify
                    taplo
                    # wezterm
                    zoom-us
                  ]) ++ (linux-mac [ tor-browser ] [ ]));
              shellAliases = { vi = "nvim -u ~/.config/home/init.lua"; };
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
              gh.enable = true;
              git.enable = true;
              home-manager.enable = true;
              kitty = {
                enable = true;
                settings = let
                  family = iosevka-name;
                  weight = "Extralight";
                  bold = "Extrabold";
                  italic = "Italic";
                  # family = "Liga SFMono Nerd Font";
                  # weight = "Light";
                  # bold = "Heavy";
                  # italic = "Italic";
                in {
                  font_family = family + " " + weight;
                  bold_font = family + " " + bold;
                  italic_font = family + " " + weight + " " + italic;
                  bold_italic_font = family + " " + bold + " " + italic;
                  font_size = linux-mac 9 12;
                };
                shellIntegration.enableZshIntegration = true;
                theme = "Ayu";
              };
              neovim = {
                enable = true;
                extraLuaConfig = builtins.readFile ./init.lua;
                plugins = (with pkgs.vimPlugins; [
                  cmp-buffer
                  cmp-cmdline
                  cmp_luasnip
                  cmp-nvim-lsp
                  cmp-path
                  comment-nvim
                  Coqtail
                  crates-nvim
                  gitsigns-nvim
                  lualine-nvim
                  luasnip
                  neovim-ayu
                  nvim-cmp
                  nvim-lspconfig
                  nvim-notify
                  nvim-treesitter-textobjects
                  sniprun
                  telescope-nvim
                ]) ++ (
                  # <https://maxwellrules.com/misc/nvim_jupyter.html>
                  [ hydrogen-textobjects jupytext ]
                  ++ (with pkgs.vimPlugins; [ iron-nvim vim-textobj-user ]));
                withPython3 = true;
              };
              ripgrep.enable = true;
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
              xsession.enable = true;
            } { });
          };
        in [
          home-manager.${(linux-mac "nixos" "darwin") + "Modules"}.home-manager
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
