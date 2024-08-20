{ laptop-name, linux-mac, nixvim, pkgs, self, system, }:
linux-mac { } { nix-daemon.enable = true; }
