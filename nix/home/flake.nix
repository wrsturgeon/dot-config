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
    configure =
      { linux-mac, nixpkgs-config, shared, stateVersion, system, username }:
      let
        homeDirectory = linux-mac "/home/${username}" "/Users/${username}";
        user-cfg = {
          home = {
            inherit homeDirectory stateVersion username;
            user-info = {
              inherit username;
              fullName = "Will Sturgeon";
              nixConfigDirectory = homeDirectory + "/.config/nix";
            };
          };
          programs = { home-manager.enable = true; };
        };
      in home-manager.${linux-mac "nixosModules" "darwinModules"}.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = { ... }: user-cfg;
        };
      };

    # in home-manager.lib.homeManagerConfiguration {
    #   pkgs = import nixpkgs nixpkgs-config;
    #   modules = [ monomodule ];
    # };
  };
}
