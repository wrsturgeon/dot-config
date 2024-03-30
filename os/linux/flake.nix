{
  description = "NixOS-specific config";
  inputs = {
    nixos-hardware = {
      flake = false;
      url = "github:kekrby/nixos-hardware";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { nixos-hardware, nixpkgs, self, }: {
    configure = { home, laptop-name, linux-mac, locale, nixpkgs-config
      , stateVersion, system, username, }:
      let pkgs = import nixpkgs nixpkgs-config;
      in {
        out = [{
          boot = {
            kernelModules = [ "applesmc" ];
            loader = {
              efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
              };
              systemd-boot.enable = true;
            };
          };
          environment = { systemPackages = with pkgs; [ libsecret ]; };
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
          i18n = {
            defaultLocale = locale;
            supportedLocales = let locales = [ "en_us.UTF-8" "fr_FR.UTF-8" ];
            in assert builtins.elem locale locales; locales;
          };
          imports =
            [ ./hardware-configuration.nix "${nixos-hardware}/apple/t2" ];
          networking.networkmanager.enable = true;
          programs = {
            dconf.enable = true;
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
            inherit stateVersion;
          };
          users = {
            users = {
              ${username} = {
                extraGroups = [ "networkmanager" "wheel" ];
                isNormalUser = true;
              };
            };
          };
        }];
      };
  };
}
