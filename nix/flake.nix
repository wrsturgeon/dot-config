{
  description = "System flakes";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
    nixfmt = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nixos/nixfmt";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nixvim";
    };
  };
  outputs =
    {
      flake-utils,
      nix-darwin,
      nixfmt,
      nixpkgs,
      nixvim,
      self,
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
        on-linux = nixpkgs.lib.strings.hasSuffix "linux" system;
        on-mac = nixpkgs.lib.strings.hasSuffix "darwin" system;
        linux-mac =
          if on-linux then
            (a: b: a)
          else if on-mac then
            (a: b: b)
          else
            throw "Unrecognized OS in system `${system}`!";

        # Usernames
        laptop-name = "mbp-" + (linux-mac "nixos" "macos");
        username = linux-mac "will" "willsturgeon";

        # Config
        stateVersion = "23.05";
        cfg-args = {
          inherit
            linux-mac
            nixfmt
            nixvim
            pkgs
            self
            stateVersion
            system
            ;
        };
        cfg = {
          inherit system;
          modules = [ (import ./config.nix cfg-args) ];
        };
      in
      {
        apps.default = {
          type = "app";
          program = ./rebuild;
        };
        packages = linux-mac { nixosConfigurations.${laptop-name} = nixpkgs.lib.nixosSystem cfg; } {
          darwinConfigurations.${laptop-name} = nix-darwin.lib.darwinSystem cfg;
        };
      }
    );
}
