{ linux-mac, nixvim, pkgs, self, system, }: {
  package = pkgs.nix;
  settings.experimental-features = "nix-command flakes";
}
