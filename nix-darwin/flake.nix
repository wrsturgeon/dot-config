{
  description = "System flake for Mac OS X";
  inputs = {
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
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
  outputs = { nix-darwin, nixpkgs, nixvim, self, sf-mono-liga-src }:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowBroken = true;
          allowUnfree = true;
        };
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
      vim = nixvim.legacyPackages.${system}.makeNixvim {
        colorschemes.ayu.enable = true;
        extraPlugins = with pkgs.vimPlugins; [ Coqtail vim-nix ];
      };
      configuration = { config, lib, modulesPath, options, specialArgs }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          coqPackages.coq
          direnv
          fd
          helix
          iterm2
          git
          gnugrep
          kitty
          # logseq
          nix-direnv
          nixfmt
          python3 # <-- for vim
          ripgrep
          (builtins.trace "${sf-mono-liga-bin}" sf-mono-liga-bin)
          spotify
          taplo
          tree
          vim
        ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = system;
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mpb-osx
      darwinConfigurations.mpb-osx =
        nix-darwin.lib.darwinSystem { modules = [ configuration ]; };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.mpb-osx.pkgs;
    };
}
