{
  description = "System flakes";
  inputs = {
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
  outputs = { home-manager, linux, mac, shared, nix-darwin, nixpkgs, self, }:
    let
      is-linux = nixpkgs.lib.strings.hasSuffix "linux";
      is-mac = nixpkgs.lib.strings.hasSuffix "darwin";
      linux-mac = on-linux: on-mac: system:
        if is-linux system then
          on-linux
        else if is-mac system then
          on-mac
        else
          throw "Unrecognized OS";
      get-username = linux-mac "will" "willsturgeon";
      config-modules = system: modules: {
        inherit system;
        modules = builtins.map (flake:
          flake.configure {
            inherit shared system;
            username = get-username system;
          }) ([ shared ] ++ modules);
      };
      laptop-name = "mbp-" + (linux-mac "nixos" "macos");
    in {
      darwinConfigurations.${laptop-name} =
        nix-darwin.lib.darwinSystem (config-modules "x86_64-darwin" [ mac ]);
      homeConfigurations.${laptop-name} =
        home-manager.lib.homeManagerConfiguration { };
      nixosConfigurations.${laptop-name} =
        nixpkgs.lib.nixosSystem (config-modules "x86_64-linux" [ linux ]);
    };
}
