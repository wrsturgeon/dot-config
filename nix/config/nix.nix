ctx: {
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
