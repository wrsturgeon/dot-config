{
  description = "Cross-platform config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, self }:
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
        let
          pkgs = import nixpkgs nixpkgs-config;
        in
        {
          out = [
            {
              environment = {
                etc = {
                  gitignore.text = ''
                    **/.DS_Store
                  '';
                };
                extraInit = ''
                  # RUN ARBITRARY CODE HERE
                '';
                pathsToLink = [ "/share/zsh" ];
                systemPackages = with pkgs; [
                  coreutils
                  gnugrep
                  gnused
                  killall
                  tree
                ];
                variables = {
                  LANG = locale;
                };
              };
              networking.hostName = laptop-name;
              nix = {
                package = pkgs.nixUnstable;
                settings = {
                  auto-optimise-store = true;
                  experimental-features = [
                    "auto-allocate-uids"
                    "configurable-impure-env"
                    "flakes"
                    "nix-command"
                  ];
                  log-lines = 32;
                  nix-path = [ "nixpkgs=flake:nixpkgs" ];
                  substituters = [ "https://cache.nixos.org" ];
                  trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
                  trusted-users = [
                    "root"
                    "${username}"
                  ];
                };
              };
              nixpkgs.hostPlatform = system;
              time.timeZone = "America/New_York";
            }
          ];
        };
    };
}
