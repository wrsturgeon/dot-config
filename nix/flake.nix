{
  description = "System flake for NixOS";
  inputs = {
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };
  outputs = { nix-doom-emacs, nixpkgs, nixvim, self, sf-mono-liga-src }:
    let
      system = "x86_64-linux";
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
      sf-mono-liga-bin = pkgs.stdenvNoCC.mkDerivation {
        pname = "sf-mono-liga-bin";
        version = "dev";
        src = sf-mono-liga-src;
        dontConfigure = true;
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp -R $src/*.otf $out/share/fonts/opentype/
        '';
      };
      vim = nixvim.legacyPackages.${system}.makeNixvim
        (import ./vim-config.nix pkgs);
      configuration = { config, lib, modulesPath, options, specialArgs }: {
        environment.systemPackages = with pkgs; [
          coqPackages.coq
          direnv
          discord
          doom-emacs
          fd
          helix
          git
          gnugrep
          kitty
          logseq
          nix-direnv
          nixfmt
          python3 # for vim only
          ripgrep
          sf-mono-liga-bin
          slack
          spotify
          taplo
          tree
          vim
          zoom-us
        ];
        fonts.packages = [ sf-mono-liga-bin ];
        nix.settings.experimental-features =
          "nix-command flakes"; # enable flakes
        nixpkgs.hostPlatform = system;
        programs = { zsh.enable = true; };
        services.nix-daemon.enable = true; # auto-upgrade
      };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ configuration ];
      };
    };
}

