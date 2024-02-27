{
  description = "MacOS-specific config";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { home, nixpkgs, self }: {
    configure =
      { home, linux-mac, nixpkgs-config, stateVersion, system, username }@configure-args: [{
        environment = {
          shellAliases.nixos-rebuild =
            "darwin-rebuild --flake .#mbp-macos --keep-going -j auto";
          packages = builtins.concatMap (cfg: if cfg ? home-manager then cfg.home-manager.users.${username}.home.packages else []) (home.configure configure-args);
        };
        security.pam.enableSudoTouchIdAuth = true;
        services.nix-daemon.enable = true;
      }];
  };
}
