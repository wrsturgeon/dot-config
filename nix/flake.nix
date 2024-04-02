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
      on =
        system: module:
        let
          cfg = {
            inherit system;
            modules = [
              (
                args:
                builtins.foldl' (import ./merge.nix) { } (
                  builtins.concatMap
                    (
                      flake:
                      builtins.map (
                        f:
                        if builtins.typeOf f != "lambda" then
                          throw "Modules should take a set argument, but one module's type was `${builtins.typeOf f}`"
                        else
                          let
                            out = f (args // { pkgs = import nixpkgs (nixpkgs-config system); });
                          in
                          if builtins.typeOf out != "set" then
                            throw "Modules should return a set, but one module's return type was `${builtins.typeOf out}`"
                          else if builtins.elem "config" out then
                            out
                          else
                            { config = out; }
                      ) (flake.configure (config-args system)).modules
                    )
                    ([
                      shared
                      module
                      home
                    ])
                )
              )
            ];
          };
          singleton =
            assert builtins.length cfg.modules == 1;
            (builtins.elemAt cfg.modules 0) {
              config = { };
              lib = { };
              pkgs = { };
              utils = { };
            };
        in
        if
          builtins.attrNames singleton != [
            "config"
            "imports"
          ]
        then
          throw "Expected config to have only `config` and `imports` attributes, but it has { ${
            builtins.foldl' (acc: s: acc + s + " ") "" (builtins.attrNames singleton)
          }}"
        else
          cfg;
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
                      cmp = "${pkgs.diffutils}/bin/cmp";
                      cp = "${pkgs.coreutils}/bin/cp";
                      date = "${pkgs.coreutils}/bin/date";
                      git = "${pkgs.git}/bin/git";
                      nix = "${pkgs.nix}/bin/nix";
                      nixfmt = "${(home.configure (config-args system)).pkgs-by-name.nixfmt}/bin/nixfmt";
                      rm = "${pkgs.coreutils}/bin/rm";
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
                      ${rm} -fr .direnv
                      ${nixfmt} .
                      ${git} add -A
                      ${cp} flake.lock flake.lock.prev
                      ${nix} flake update
                      ${cmp} -s flake.lock flake.lock.prev || { echo "Nix updated some inputs; re-running for consistency..."; ${nix} run ${./.}; }
                      ${rm} flake.lock.prev
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
                    + (linux-mac system ''
                      cd /etc/nixos
                      sudo ${git} pull
                    '' "")
                    + ''
                        ${
                          linux-mac system "sudo nixos" "${nix-darwin.packages.${system}.default}/bin/darwin"
                        }-rebuild switch --flake ${./.} --keep-going -v -j auto --show-trace # --install-bootloader"

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
      lib.config = {
        linux = on linux-system linux;
        mac = on linux-system mac;
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
