{
  description = "MacOS-specific config";
  inputs = { };
  outputs =
    { self }:
    {
      lib.configure =
        {
          home,
          laptop-name,
          linux-mac,
          locale,
          nixpkgs-config,
          stateVersion,
          system,
          username,
        }:
        {
          modules = [
            (
              { ... }:
              {
                environment = {
                  shellAliases.nixos-rebuild = "darwin-rebuild --flake ~/.config --keep-going -j auto";
                };
                launchd.envVariables = {
                  LANG = locale;
                };
                security.pam.enableSudoTouchIdAuth = true;
                services.nix-daemon.enable = true;
              }
            )
          ];
        };
    };
}
