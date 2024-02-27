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
        nixpkgs-config = system: {
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
            flake.configure {
              inherit shared system username;
              nixpkgs-config = nixpkgs-config system;
            }) ([ shared ] ++ modules);
        };
        laptop-name = "mbp-" + (linux-mac "nixos" "macos");
      in let
        common = {
          homeConfigurations.${laptop-name} =
            home-manager.lib.homeManagerConfiguration { };
        };
        if-mac = if is-mac system then {
          darwinConfigurations.${laptop-name} =
            nix-darwin.lib.darwinSystem (config-modules [ mac ]);
        } else
          { };
        if-linux = if is-linux system then {
          nixosConfigurations.${laptop-name} =
            nixpkgs.lib.nixosSystem (config-modules [ linux ]);
        } else
          { };
      in { packages = common // if-mac // if-linux; });
}
