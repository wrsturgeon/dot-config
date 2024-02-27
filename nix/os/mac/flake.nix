{
  description = "MacOS-specific config";
  inputs = { };
  outputs = { self }:
    { shared, system, username }: {
      environment = {
        shellAliases.nixos-rebuild =
          "darwin-rebuild --flake .#macbook-macos --keep-going -j auto";
        systemPackages = shared.users.users.${username}.packages;
      };
      nix.linux-builder.enable = true;
      security.pam.enableSudoTouchIdAuth = true;
      services.nix-daemon.enable = true;
    };
}
