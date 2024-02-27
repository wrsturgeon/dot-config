{
  description = "Home Manager config";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { home-manager, nixpkgs, self }: {
    configure = { nixpkgs-config, shared, system, username }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs nixpkgs-config;
        modules = [ ];
      };
  };
}
