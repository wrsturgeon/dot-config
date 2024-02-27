{
  description = "System flakes";
  inputs = {
    home = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./home";
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
  outputs = { home, linux, mac, shared, nix-darwin, nixpkgs, self, }:
    let
      is-linux = nixpkgs.lib.strings.hasSuffix "linux";
      is-mac = nixpkgs.lib.strings.hasSuffix "darwin";
      linux-mac = system: on-linux: on-mac:
        if is-linux system then
          on-linux
        else if is-mac system then
          on-mac
        else
          throw ''Unrecognized OS "${system}"'';
      nixpkgs-config = system: {
        inherit system;
        config = {
          allowBroken = true;
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
      };
      stateVersion = "23.05";
      config-args = system: {
        inherit shared stateVersion system;
        linux-mac = linux-mac system;
        nixpkgs-config = nixpkgs-config system;
        username = linux-mac system "will" "willsturgeon";
      };
      on = system: modules: {
        inherit system;
        modules = builtins.map (flake: flake.configure (config-args system))
          ([ home shared ] ++ modules);
      };
      laptop-name = system: "mbp-" + (linux-mac system "nixos" "macos");
    in {
      darwinConfigurations = let system = "x86_64-darwin";
      in {
        ${laptop-name system} = nix-darwin.lib.darwinSystem (on system [ mac ]);
      };
      nixosConfigurations = let system = "x86_64-linux";
      in {
        ${laptop-name system} = nixpkgs.lib.nixosSystem (on system [ linux ]);
      };
    };
}
