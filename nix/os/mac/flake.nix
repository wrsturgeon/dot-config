{
  description = "MacOS-specific config";
  inputs = { home = { inputs.nixpkgs.follows = "nixpkgs"; url = "path:../home"; }; nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { home, nixpkgs, self }: {
    configure =
      { linux-mac, nixpkgs-config, shared, stateVersion, system, username }@configure-args: [{
        environment = {
          shellAliases.nixos-rebuild =
            "darwin-rebuild --flake .#mbp-macos --keep-going -j auto";
          packages = (home.configure configure-args).users.${username}.home.packages;
        };
        security.pam.enableSudoTouchIdAuth = true;
        services.nix-daemon.enable = true;
      }];
  };
}
