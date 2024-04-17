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
      linux-system = "x86_64-linux";
      mac-system = "x86_64-darwin";
      systems = [
        linux-system
        mac-system
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
        modules = builtins.concatMap (flake: (flake.configure (config-args system)).modules) [
          shared
          module
          home
        ];
      };
    in
    {
      apps =
        let
          rebuild-on =
            system:
            let
              pkgs = import nixpkgs (nixpkgs-config system);
              chmod = "${pkgs.coreutils}/bin/chmod";
              cmp = "${pkgs.diffutils}/bin/cmp";
              cp = "${pkgs.coreutils}/bin/cp";
              date = "${pkgs.coreutils}/bin/date";
              echo = "${pkgs.coreutils}/bin/echo";
              git = "${pkgs.git}/bin/git";
              grep = "${pkgs.gnugrep}/bin/grep";
              mkdir = "${pkgs.coreutils}/bin/mkdir";
              nix = "${pkgs.nix}/bin/nix";
              nixfmt = "${(home.configure (config-args system)).pkgs-by-name.nixfmt}/bin/nixfmt";
              rm = "${pkgs.coreutils}/bin/rm";
              uname = "${pkgs.coreutils}/bin/uname";
            in
            {
              type = "app";
              program = "${
                let
                  rebuild-script =
                    ''
                      #!${pkgs.bash}/bin/bash

                      set -eux

                      export COMMIT_DATE="$(${date} "+%B %-d, %Y, at %H:%M:%S") on $(${uname} -s)"

                      # Push ~/.config changes
                      cd ~/.config
                      ${git} pull
                      cd nix
                      ${rm} -fr .direnv
                      ${nixfmt} .
                      ${git} add -A
                      ${cp} flake.lock flake.lock.prev
                      ${nix} flake update || : # rate limits!
                      ${cmp} -s flake.lock flake.lock.prev || { ${echo} "Nix updated some inputs; re-running for consistency..."; ${nix} run ~/.config/nix; }
                      ${rm} flake.lock.prev
                      ${git} add -A
                      ${git} commit -m "''${COMMIT_DATE}" || :
                      ${git} push || :

                      # Synchronize Logseq notes
                      cd ~/Desktop/logseq
                      ${git} pull
                      ${git} submodule update --init --recursive --remote
                      export FIRST_YEAR=0
                      export LAST_YEAR=3000
                      for year in $(seq ''${FIRST_YEAR} ''${LAST_YEAR}); do
                          ${rm} -f pages/''${year}.md
                      done
                      for year in $(seq ''${LAST_YEAR} -1 ''${FIRST_YEAR}); do
                          # Have to iterate backward b/c the below creates a file containing the next year!
                          if ${grep} -nqr "\[\[''${year}\]\]" pages; then
                              # Could eliminate some redundancy by skipping loop iterations here but fuck it
                              if ${grep} -nqr "\[\[''$((year+1))\]\]" pages; then
                                  ${echo} "- year before [[$((year+1))]]" > pages/''${year}.md
                              fi
                          fi
                      done
                      ${git} add -A
                      ${git} commit -m "''${COMMIT_DATE}" || :
                      ${git} push

                      # Rebuild the Nix system
                    ''
                    + (linux-mac system ''
                      cd /etc/nixos
                      sudo ${git} pull
                    '' "")
                    + ''
                        ${
                          linux-mac system "sudo nixos-rebuild" "${nix} run nix-darwin --"
                        } switch --flake ${./.} --keep-going -v -j auto --show-trace # --install-bootloader

                      # Collect garbage
                      ${pkgs.nix}/bin/nix-collect-garbage -j auto --delete-older-than 14d > /dev/null 2>&1 &
                    '';
                in
                pkgs.stdenv.mkDerivation {
                  name = "reload";
                  src = ./.;
                  buildPhase = ":";
                  installPhase = ''
                    ${mkdir} -p $out/bin
                    ${echo} '${rebuild-script}' > $out/bin/rebuild
                    ${chmod} +x $out/bin/rebuild
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
          system = mac-system;
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
                packages = with pkgs; [
                  lua-language-server
                  nix
                  stylua
                ];
              };
            };
        in
        builtins.listToAttrs (
          builtins.map (name: {
            inherit name;
            value = shell-on name;
          }) systems
        );
      lib.config =
        let
          f =
            system: module:
            builtins.elemAt (on system module).modules 0 {
              config = { };
              inherit (nixpkgs) lib;
              utils = { };
            };
        in
        {
          linux = f linux-system linux;
          mac = f linux-system mac;
        };
      nixosConfigurations =
        let
          system = linux-system;
        in
        {
          ${laptop-name system} = nixpkgs.lib.nixosSystem (on system linux);
        };
    };
}
