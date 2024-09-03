{
  description = "System flakes";
  inputs = {
    # apple-fonts = {
    #   url = "github:lyndeno/apple-fonts.nix";
    #   inputs = {
    #     flake-utils.follows = "flake-utils";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    github-dark-nvim-src = {
      flake = false;
      url = "github:vv9k/vim-github-dark";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nixvim";
    };
    # sf-mono-liga-src = {
    #   flake = false;
    #   url = "github:shaunsingh/sfmono-nerd-font-ligaturized";
    # };
  };
  outputs =
    {
      # apple-fonts,
      fenix,
      flake-utils,
      github-dark-nvim-src,
      nix-darwin,
      nixpkgs,
      nixvim,
      self,
    # sf-mono-liga-src
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let

        # Nixpkgs
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        # OS introspection utils
        on-linux = pkgs.lib.strings.hasSuffix "linux" system;
        on-mac = pkgs.lib.strings.hasSuffix "darwin" system;
        linux-mac =
          if on-linux then
            (a: b: a)
          else if on-mac then
            (a: b: b)
          else
            throw "Unrecognized OS in system `${system}`!";

        # Usernames
        laptop-name = "willsturgeon"; # "mbp-" + (linux-mac "nixos" "macos");
        # username = linux-mac "will" "willsturgeon";

        # Kitty terminal emulator
        kitty = import ./config/programs/kitty cfg-args;
        terminal-settings = rec {
          font-size = 13;
          dark = true;
          # weight = if dark then "Light" else "Regular";
          # italic = if dark then "Light Italic" else "Italic";
          weight = "Regular";
          italic = "Italic";
          theme = if dark then "ayu" else "ayu-light";
        };

        # Custom fonts
        iosevka = pkgs.iosevka.override {
          # <https://github.com/be5invis/Iosevka/blob/main/doc/language-specific-ligation-sets.md>
          privateBuildPlan = {
            exportGlyphNames = true;
            family = "Iosevka Custom";
            # <https://github.com/be5invis/Iosevka?tab=readme-ov-file#ligations>
            ligations = {
              # enable all those not enabled by `dlig` below
              # (see the above link for a visual depiction):
              enables = [
                "eqexeq"
                "eqslasheq"
                "slasheq"
                "tildeeq"
              ];
              inherits = "dlig";
            };
            noCvSs = false;
            noLigation = false;
            spacing = "fontconfig-mono";
            variants.inherits = "ss08";
            webfontFormats = [ ]; # i.e. none
          };
          set = "custom";
        };

        # GitHub Dark theme for Neovim
        github-dark-nvim = pkgs.stdenvNoCC.mkDerivation {
          name = "github-dark-nvim";
          version = "git";
          src = github-dark-nvim-src;
          buildPhase = ":";
          installPhase = ''
            cp -r . $out
          '';
        };

        # Print deeply evaluated attribute sets
        print =
          x:
          builtins.trace x (
            if builtins.isAttrs x then
              "{ ${
                pkgs.lib.strings.concatStringsSep "; " (
                  builtins.attrValues (builtins.mapAttrs (k: v: "${k} = ${print v}") x)
                )
              } }"
            else if builtins.isString x then
              x
            else if builtins.isNull x then
              "<null>"
            else if builtins.isBool x then
              if x then "true" else "false"
            else if builtins.isList x then
              "[ ${builtins.map (z: "(${print z}) ") x}]"
            else
              builtins.toString x
          );

        # Config
        cfg-args = {
          inherit
            github-dark-nvim
            iosevka
            laptop-name
            linux-mac
            nixvim
            pkgs
            print
            self
            system
            terminal-settings
            ;
          dock-apps =
            [ kitty ]
            ++ (with pkgs; [
              spotify
              discord
              slack
              arc-browser
              logseq
            ]);
          emacs = import ./config/programs/emacs cfg-args;
          git = pkgs.gitFull;
          kitty-config = import ./config/programs/kitty/config.nix cfg-args;
          rust = fenix.packages.${system}.minimal;
          vim = nixvim.legacyPackages.${system}.makeNixvim (import ./config/programs/neovim cfg-args);
        };
        cfg = {
          inherit system;
          modules = [
            (builtins.mapAttrs (_: filename: import ./config/system/${filename} cfg-args) (
              builtins.listToAttrs (
                builtins.map
                  (filename: {
                    name = pkgs.lib.strings.removeSuffix ".nix" filename;
                    value = filename;
                  })
                  (
                    builtins.filter (pkgs.lib.strings.hasSuffix ".nix") (
                      builtins.attrNames (builtins.readDir ./config/system)
                    )
                  )
              )
            ))
          ];
        };
      in
      {
        apps.default = {
          type = "app";
          program = ./rebuild;
        };
        packages = linux-mac { nixosConfigurations.${laptop-name} = pkgs.lib.nixosSystem cfg; } {
          darwinConfigurations.${laptop-name} = nix-darwin.lib.darwinSystem cfg;
        };
      }
    );
}
