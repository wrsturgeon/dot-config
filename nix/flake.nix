{
  description = "System flakes";
  inputs = {
    home = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./home";
    };
    linux = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./os/linux";
    };
    mac.url = "path:./os/mac";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    shared = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "path:./os/shared";
    };
  };
  outputs =
    {
      home,
      linux,
      mac,
      shared,
      nix-darwin,
      nixpkgs,
      self,
    }:
    let
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
      is-linux = nixpkgs.lib.strings.hasSuffix "linux";
      is-mac = nixpkgs.lib.strings.hasSuffix "darwin";
      linux-mac =
        system: on-linux: on-mac:
        if is-linux system then
          on-linux
        else if is-mac system then
          on-mac
        else
          throw ''Unrecognized OS "${system}"'';
      nixpkgs-config = system: {
        inherit system;
        config = {
          allowBroken = true;
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
      };
      stateVersion = "23.05";
      laptop-name = system: "mbp-" + (linux-mac system "nixos" "macos");
      username = system: linux-mac system "will" "willsturgeon";
      config-args = system: {
        inherit home stateVersion system;
        laptop-name = laptop-name system;
        linux-mac = linux-mac system;
        locale = "fr_FR.UTF-8";
        nixpkgs-config = nixpkgs-config system;
        username = username system;
      };
      on = system: module: {
        inherit system;
        modules =
          let
            altogether = builtins.concatMap (flake: (flake.configure (config-args system)).modules) ([
              shared
              module
              home
            ]);
          in
          builtins.trace altogether altogether;
      };
    in
    {
      apps =
        let
          rebuild-on =
            system:
            let
              pkgs = import nixpkgs (nixpkgs-config system);
            in
            {
              type = "app";
              program = "${
                let
                  rebuild-script =
                    let
                      date = "${pkgs.coreutils}/bin/date";
                      git = "${pkgs.git}/bin/git";
                      nix = "${pkgs.nix}/bin/nix";
                      nixfmt = "${(home.configure (config-args system)).pkgs-by-name.nixfmt}/bin/nixfmt";
                      uname = "${pkgs.coreutils}/bin/uname";
                    in
                    ''
                      #!${pkgs.bash}/bin/bash

                      set -eux

                      export COMMIT_DATE="$(${date} "+%B %-d, %Y, at %H:%M:%S") on $(${uname} -s)"

                      # Push ~/.config changes
                      cd ~/.config
                      ${git} pull
                      cd nix
                      rm -fr .direnv
                      ${nixfmt} .
                      ${git} add -A
                      ${nix} flake update
                      ${git} add -A
                      ${git} commit -m "''${COMMIT_DATE}" || :
                      ${git} push || :

                      # Synchronize Logseq notes
                      cd ~/Desktop/logseq
                      ${git} pull
                      ${git} submodule update --init --recursive --remote
                      ${git} add -A
                      ${git} commit -m "''${COMMIT_DATE}" || :
                      ${git} push

                      # Rebuild the Nix system
                    ''
                    + (linux-mac system
                      ''
                        cd /etc/nixos
                        sudo ${git} pull
                        sudo nixos-rebuild switch -v -j auto # --install-bootloader
                        # ${nix} shell nixpkgs#efibootmgr nixpkgs#refind -c refind-install
                      ''
                      ''
                        # darwin-rebuild switch --flake ~/.config --keep-going -j auto
                        ${
                          nix-darwin.packages.${system}.default
                        }/bin/darwin-rebuild switch --flake ${./.} --keep-going -j auto
                      ''
                    )
                    + ''

                      # Collect garbage
                      ${pkgs.nix}/bin/nix-collect-garbage -j auto --delete-older-than 14d > /dev/null 2>&1 &
                    '';
                in
                pkgs.stdenv.mkDerivation {
                  name = "reload";
                  src = ./.;
                  buildPhase = ":";
                  installPhase = ''
                    mkdir -p $out/bin
                    echo '${rebuild-script}' > $out/bin/rebuild
                    chmod +x $out/bin/rebuild
                  '';
                }
              }/bin/rebuild";
            };
        in
        builtins.foldl' (
          acc: system:
          acc
          // {
            ${system} = {
              rebuild = rebuild-on system;
              default = self.apps.${system}.rebuild;
            };
          }
        ) { } systems;
      darwinConfigurations =
        let
          system = "x86_64-darwin";
        in
        {
          ${laptop-name system} = nix-darwin.lib.darwinSystem (on system mac);
        };
      devShells =
        let
          shell-on =
            system:
            let
              pkgs = import nixpkgs (nixpkgs-config system);
            in
            {
              default = pkgs.mkShell {
                packages =
                  let
                    h = home.configure (config-args system);
                  in
                  h.user-cfg.home.packages
                  ++ (builtins.attrValues (
                    builtins.mapAttrs (k: v: if v ? program then v.program else pkgs.${k}) h.user-cfg.programs
                  ))
                  ++ (with pkgs; [
                    lua-language-server
                    nix
                    stylua
                  ]);
              };
            };
        in
        builtins.listToAttrs (
          builtins.map (name: {
            inherit name;
            value = shell-on name;
          }) systems
        );
      nixosConfigurations =
        let
          system = "x86_64-linux";
        in
        {
          ${laptop-name system} = nixpkgs.lib.nixosSystem (on system linux);
        };
    };
}
