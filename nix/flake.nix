{
  description = "System flakes";
  inputs = let
    pin-pkgs = name: value:
      if name == "nixpkgs" || ((value ? flake) && (value.flake == false)) then
        value
      else
        (value // { inputs.nixpkgs.follows = "nixpkgs"; });
  in builtins.mapAttrs pin-pkgs {
    linux.url = "git+file:nix/os/linux";
    mac.url = "git+file:nix/os/mac";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    shared.url = "git+file:nix/os/shared";
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
      config-modules = system: modules: {
        inherit system;
        modules = builtins.map (config:
          config {
            inherit system;
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
