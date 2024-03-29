{
  description = "MacOS-specific config";
  inputs = { };
  outputs =
    { self }:
    {
      configure =
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
        [
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
        ];
    };
}
