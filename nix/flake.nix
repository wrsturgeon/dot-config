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

        # Config
        cfg-args = {
          inherit
            iosevka
            laptop-name
            linux-mac
            nixvim
            pkgs
            self
            system
            ;
          dock-apps = with pkgs; [
            spotify
            discord
            slack
            arc-browser
            (kitty.override {
              python3Packages = pkgs.python3Packages // {
                buildPythonApplication =
                  cfg:
                  pkgs.python3Packages.buildPythonApplication (
                    cfg
                    // {
                      configurePhase = ''
                        ${cfg.configurePhase}
                        sed -i 's/raise SystemExit.*font.*was not found on your system, please install it.*/return/g' setup.py
                      '';
                      installPhase = ''
                        ls -A
                        exit
                        ${cfg.installPhase}
                        cp ${iosevka}/share/fonts/truetype/Iosevkacustom-Bold.ttf $out/Applications/kitty.app/Contents/Resources/kitty/kitty/fonts/NerdFontsSymbolsOnly.tff
                        cp ${iosevka}/share/fonts/truetype/Iosevkacustom-Regular.ttf $out/Applications/kitty.app/Contents/Resources/kitty/kitty/fonts/SymbolsNerdFontMono-Regular.ttf
                      '';
                      nativeBuildInputs =
                        cfg.nativeBuildInputs
                        ++ (with pkgs.python3Packages; [
                          matplotlib
                        ]);
                    }
                  );
              };
            })
            # wezterm
            logseq
          ];
          emacs = import ./config/programs/emacs cfg-args;
          git = pkgs.gitFull;
          vim = nixvim.legacyPackages.${system}.makeNixvim (import ./config/programs/vim cfg-args);
          rust = fenix.packages.${system}.minimal;
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
