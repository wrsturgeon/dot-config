{
  description = "Cross-platform config";
  inputs = {
    nix-doom-emacs = {
      # inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-doom-emacs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { nix-doom-emacs, nixpkgs, self }: {
    config = { shared, system, username }:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowBroken = true;
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
        doom-emacs = nix-doom-emacs.packages.${system}.default.override {
          doomPrivateDir = ./doom.d;
        };
        vim-configured = pkgs.vim-full.customize {
          name = "vim-configured";
          vimrcConfig = {
            packages.myplugins = with pkgs.vimPlugins; {
              start = [
                ale
                ayu-vim
                Coqtail
                fugitive
                fzf-vim
                gitgutter
                vim-airline
                vim-nix
              ];
              opt = [ ];
            };
            customRC = builtins.readFile ./.vimrc;
          };
        };
      in {
        # config.home-manager = {
        #   useGlobalPkgs = true;
        #   useUserPackages = true;
        # };
        environment = {
          etc = {
            gitignore.text = ''
              **/.DS_Store
            '';
          };
          extraInit = ''
            echo '# File managed by NixOS: all changes will be overwritten.' > ~/.zshrc
          '';
          shellAliases = {
            e = "emacs";
            emacs = "doom run -nw";
            vi = "vim";
          };
          systemPackages = with pkgs; [
            cachix
            coreutils
            git
            gnugrep
            helix
            killall
            kitty
            nil
            nixfmt
            python3
            ripgrep
            tree
            vim-configured
          ];
          variables = { NIXOS_INSTALL_BOOTLOADER = "1"; };
        };
        # home-manager.users.${username} = {
        #   home.packages = with pkgs; [ ];
        #   programs = { };
        # };
        networking.hostName = "mbp-nixos";
        nix = {
          extraOptions = "experimental-features = flakes nix-command";
          package = pkgs.nixUnstable;
          settings = {
            auto-optimise-store = true;
            experimental-features = [ "flakes" "nix-command" ];
            log-lines = 32;
            nix-path = [ "nixpkgs=flake:nixpkgs" ];
            substituters = [ "https://cache.nixos.org" ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            ];
            trusted-users = [ "root" "${username}" ];
          };
        };
        nixpkgs.hostPlatform = system;
        programs = {
          gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
          };
          zsh = {
            enable = true;
            promptInit = ''
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
          };
        };
        time.timeZone = "America/New_York";
        users.users.${username} = {
          description = "Will";
          packages = with pkgs; [
            cargo
            coqPackages.coq
            direnv
            discord
            doom-emacs
            fd
            fzf
            gcc
            github-cli
            gnumake
            logseq
            nix-direnv
            rust-analyzer
            rustfmt
            slack
            spotify
            taplo
            zoom-us
          ];
          shell = pkgs.zsh;
        };
      };
  };
}
