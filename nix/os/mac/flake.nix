{
  description = "MacOS-specific config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shared = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:../shared";
    };
  };
  outputs = { nixpkgs, self, shared }:
    { system, username }: {
      environment = {
        shellAliases.nixos-rebuild =
          "darwin-rebuild --flake .#macbook-macos --keep-going -j auto";
        systemPackages =
          shared { inherit system username; }.users.users.${username}.packages;
      };
      nix.linux-builder.enable = true;
      security.pam.enableSudoTouchIdAuth = true;
      services.nix-daemon.enable = true;
    };
}
