{
  description = "NixOS-specific config";
  inputs = {
    apple-fonts = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lyndeno/apple-fonts.nix";
    };
    nixos-hardware = {
      flake = false;
      url = "github:kekrby/nixos-hardware";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    sf-mono-liga-src = {
      flake = false;
      url = "github:shaunsingh/sfmono-nerd-font-ligaturized";
    };
  };
  outputs = { apple-fonts, nixos-hardware, nixpkgs, sf-mono-liga-src, self }: {
    configure = { nixpkgs-config, shared, system, username }:
      let
        pkgs = import nixpkgs nixpkgs-config;
        print-list = builtins.foldl' (acc: s: acc + " " + s) "";
        apple-font-packages = apple-fonts.packages.${system};
        apple-font-names = builtins.attrNames apple-font-packages;
        nerdless-apple-font-names =
          builtins.filter (s: !(pkgs.lib.strings.hasSuffix "nerd" s))
          apple-font-names;
        nerdless-apple-fonts = map (s: apple-font-packages.${s})
          (builtins.trace "Apple fonts:${print-list nerdless-apple-font-names}"
            nerdless-apple-font-names);
        sf-mono-liga-bin = pkgs.stdenvNoCC.mkDerivation {
          pname = "sf-mono-liga-bin";
          version = "dev";
          src = sf-mono-liga-src;
          dontConfigure = true;
          installPhase = ''
            mkdir -p $out/share/fonts/opentype
            cp -R $src/*.otf $out/share/fonts/opentype/
          '';
        };
      in {
        boot = {
          kernelModules = [ "applesmc" ];
          loader = {
            efi = {
              canTouchEfiVariables = true;
              efiSysMountPoint = "/boot/efi";
            };
            grub = {
              devices = [ "nodev" ];
              enable = true;
              efiSupport = true;
              useOSProber = true;
            };
            # systemd-boot.enable = true;
          };
        };
        environment = { systemPackages = with pkgs; [ libsecret ]; };
        fonts.packages = nerdless-apple-fonts ++ [ sf-mono-liga-bin ]
          ++ (with pkgs; [
            cascadia-code
            fira-code
            ibm-plex
            iosevka
            recursive
          ]);
        hardware.firmware = [
          (pkgs.stdenvNoCC.mkDerivation {
            pname = "brcm-firmware";
            version = "none";
            buildCommand = ''
              dir="$out/lib/firmware"
              mkdir -p "$dir"
              cp -r ${./firmware}/* "$dir"
            '';
          })
        ];
        i18n.defaultLocale = "en_US.UTF-8";
        imports = [ ./hardware-configuration.nix "${nixos-hardware}/apple/t2" ];
        networking.networkmanager.enable = true;
        programs = {
          dconf.enable = true;
          git = {
            config = {
              commit.gpgSign = true;
              credential.helper = "libsecret";
              user.signingKey = "5C775F8013C226F4";
            };
            enable = true;
            package = pkgs.gitFull;
          };
          mtr.enable = true;
          pantheon-tweaks.enable = true;
        };
        services = {
          openssh.enable = true;
          pantheon.apps.enable = false;
          xserver = {
            desktopManager.pantheon.enable = true;
            displayManager.lightdm.enable = true;
            enable = true;
            xkb.layout = "us";
            libinput.enable = true;
          };
        };
        system = {
          autoUpgrade = {
            dates = "04:00";
            enable = true;
            flags = [ "--update-input" "nixpkgs" ];
            allowReboot = true;
          };
          stateVersion = "23.05";
        };
        users = {
          users = {
            ${username} = {
              extraGroups = [ "networkmanager" "wheel" ];
              isNormalUser = true;
              packages = with pkgs; [ firefox ];
            };
          };
        };
      };
  };
}
