{
  description = "MacOS-specific config";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { nixpkgs, self }: {
    configure = { home, laptop-name, linux-mac, nixpkgs-config, stateVersion
      , system, username }@configure-args:
      let pkgs = import nixpkgs nixpkgs-config;
      in [{
        environment = {
          shellAliases.nixos-rebuild =
            "darwin-rebuild --flake ~/.config/nix --keep-going -j auto";
          # systemPackages = builtins.concatMap (cfg:
          #   if cfg ? home-manager then
          #     cfg.home-manager.users.${username}.home.packages ++ (builtins.map
          #       (pkg:
          #         if pkg == "gh" then
          #           pkgs.github-cli
          #         else if pkg == "gpg" then
          #           pkgs.gnupg
          #         else
          #           pkgs.${pkg}) (builtins.attrNames
          #             cfg.home-manager.users.${username}.programs))
          #   else
          #     [ ]) (home.configure configure-args);
        };
        security.pam.enableSudoTouchIdAuth = true;
        services.nix-daemon.enable = true;
      }];
  };
}
