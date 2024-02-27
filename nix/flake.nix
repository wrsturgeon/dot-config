{
  description = "System flakes";
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        is-linux = nixpkgs.lib.strings.hasSuffix "linux";
        is-mac = nixpkgs.lib.strings.hasSuffix "darwin";
        linux-mac = on-linux: on-mac:
          if is-linux system then
            on-linux
          else if is-mac system then
            on-mac
          else
            throw "Unrecognized OS";
        username = linux-mac "will" "willsturgeon";
        config-modules = modules: {
          inherit system;
          modules = builtins.map
            (flake: flake.configure { inherit username shared system; })
            ([ shared ] ++ modules);
        };
        laptop-name = "mbp-" + (linux-mac "nixos" "macos");
      in {
        darwinConfigurations.${laptop-name} =
          nix-darwin.lib.darwinSystem (config-modules [ mac ]);
        homeConfigurations.${laptop-name} =
          home-manager.lib.homeManagerConfiguration { };
        nixosConfigurations.${laptop-name} =
          nixpkgs.lib.nixosSystem (config-modules [ linux ]);
      });
}
