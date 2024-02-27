{
  description = "System flakes";
  inputs = {
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
  outputs = { linux, mac, shared, nix-darwin, nixpkgs, self, }:
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
      config-modules = system: modules:
        builtins.trace (builtins.typeOf modules) {
          inherit system;
          modules = builtins.map (flake:
            flake.configure {
              inherit shared system;
              username = get-username system;
            }) (shared ++ modules);
        };
    in {
      nixosConfigurations.mbp-nixos =
        nixpkgs.lib.nixosSystem (config-modules "x86_64-linux" [ linux ]);
      darwinConfigurations.macbook-macos =
        nix-darwin.lib.darwinSystem (config-modules "x86_64-darwin" [ mac ]);
    };
}
