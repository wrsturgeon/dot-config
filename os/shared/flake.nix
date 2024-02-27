{
  description = "Cross-platform config";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
  outputs = { nixpkgs, self }: {
    configure = { home, laptop-name, linux-mac, nixpkgs-config, stateVersion
      , system, username }:
      let pkgs = import nixpkgs nixpkgs-config;
      in [{
        environment = {
          etc = {
            gitignore.text = ''
              **/.DS_Store
            '';
          };
          extraInit = ''
            rm -fr ~/emacs.el ~/.emacs ~/.emacs.d
            emacsclient --eval '(load-file "~/.config/emacs/init.el")'
          '';
          pathsToLink = [ "/share/zsh" ];
          shellAliases = {
            e = "emacsclient -nw";
            vi = "vim";
          };
          systemPackages = with pkgs; [ coreutils gnugrep killall tree ];
          variables = {
            NIXOS_INSTALL_BOOTLOADER = "1";
            XDG_CONFIG_HOME = "~/.config";
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
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            ];
            trusted-users = [ "root" "${username}" ];
          };
        };
        nixpkgs.hostPlatform = system;
        programs.zsh.enable = true;
        services.emacs = {
          enable = true;
          package = pkgs.emacs;
        };
        time.timeZone = "America/New_York";
        users.users.${username} = {
          description = "Will";
          home = linux-mac "/home/${username}" "/Users/${username}";
          name = username;
          shell = pkgs.zsh;
        };
      }];
  };
}
