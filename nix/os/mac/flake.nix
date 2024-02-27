{
  description = "MacOS-specific config";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { nixpkgs, self }: {
    configure = { linux-mac, nixpkgs-config, shared, stateVersion, system
      , username }@config-args:
      let pkgs = import nixpkgs nixpkgs-config;
      in [{
        environment = {
          shellAliases.nixos-rebuild =
            "darwin-rebuild --flake .#mbp-macos --keep-going -j auto";
          systemPackages =
            builtins.concatMap (cfg: cfg.users.users.${username}.packages)
            (shared.configure config-args);
        };
        nix.linux-builder.enable = true;
        security.pam.enableSudoTouchIdAuth = true;
        services.nix-daemon.enable = true;
      }];
  };
}
