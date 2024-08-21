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
        username = linux-mac "will" "willsturgeon";

        # Config
        cfg-args = {
          inherit
            laptop-name
            linux-mac
            nixvim
            pkgs
            self
            system
            ;
          emacs = pkgs.emacs-nox;
        };
        cfg = {
          inherit system;
          modules = [
            (builtins.mapAttrs (_: filename: import config/${filename} cfg-args) (
              builtins.listToAttrs (
                builtins.map
                  (filename: {
                    name = pkgs.lib.strings.removeSuffix ".nix" filename;
                    value = filename;
                  })
                  (
                    builtins.filter (pkgs.lib.strings.hasSuffix ".nix") (builtins.attrNames (builtins.readDir ./config))
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
