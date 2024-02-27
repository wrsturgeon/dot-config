{
  description = "MacOS-specific config";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { nixpkgs, self }: {
    configure = { shared, system, username }: {
      environment = {
        shellAliases.nixos-rebuild =
          "darwin-rebuild --flake .#macbook-macos --keep-going -j auto";
        systemPackages = (shared.configure {
          inherit shared system username;
        }).users.users.${username}.packages;
      };
      nix.linux-builder.enable = true;
      security.pam.enableSudoTouchIdAuth = true;
      services.nix-daemon.enable = true;
    };
  };
}
