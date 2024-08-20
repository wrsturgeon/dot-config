{
  laptop-name,
  linux-mac,
  nixvim,
  pkgs,
  self,
  system,
}:
{
  package = pkgs.nix;
  settings = {
    # auto-optimize-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    log-lines = 64;
  };
}
