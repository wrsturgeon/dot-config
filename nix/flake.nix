{
  description = "System flakes";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    linux = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./os/linux";
    };
    mac = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./os/mac";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    shared = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./os/shared";
    };
  };
  outputs = { flake-utils, home-manager, linux, mac, shared, nix-darwin, nixpkgs
    , self, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        is-linux = nixpkgs.lib.strings.hasSuffix "linux" system;
        is-mac = nixpkgs.lib.strings.hasSuffix "darwin" system;
        linux-mac = on-linux: on-mac:
          if is-linux then
            on-linux
          else if is-mac then
            on-mac
          else
            throw "Unrecognized OS";
        username = linux-mac "will" "willsturgeon";
        nixpkgs-config = {
          inherit system;
          config = {
            allowBroken = true;
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
        config-modules = modules: {
          inherit system;
          modules = builtins.map (flake:
            flake.configure { inherit nixpkgs-config shared system username; })
            ([ shared ] ++ modules);
        };
        laptop-name = "mbp-" + (linux-mac "nixos" "macos");
      in let
        common = {
          homeConfigurations.${laptop-name} =
            home-manager.lib.homeManagerConfiguration { };
        };
        if-mac = {
          darwinConfigurations.${laptop-name} =
            nix-darwin.lib.darwinSystem (config-modules [ mac ]);
        };
        if-linux = {
          nixosConfigurations.${laptop-name} =
            nixpkgs.lib.nixosSystem (config-modules [ linux ]);
        };
      in {
        packages = common // (if is-mac then if-mac else { })
          // (if is-linux then if-linux else { });
      });
}
