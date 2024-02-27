{
  description = "Home Manager config";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { home-manager, nixpkgs, self }: {
    configure =
      { linux-mac, nixpkgs-config, shared, stateVersion, system, username }:
      let
        pkgs = import nixpkgs nixpkgs-config;
        user-cfg = {
          home = { inherit stateVersion username; };
          programs = {
            home-manager.enable = true;
            vim = {
              enable = true;
              extraConfig = builtins.readFile ./vimrc;
              plugins = with pkgs.vimPlugins; [
                ale
                ayu-vim
                Coqtail
                fugitive
                fzf-vim
                gitgutter
                vim-airline
                vim-nix
              ];
            };
          };
        } // (linux-mac {
          xsession.enable = true;
          # xsession.windowManager.command = "...";
        } { });
      in [
        home-manager.${linux-mac "nixosModules" "darwinModules"}.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = user-cfg;
          };
        }
      ];
  };
}
