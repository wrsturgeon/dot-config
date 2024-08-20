ctx: {
  channel.enable = false;
  optimize.automatic = true;
  settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    log-lines = 64;
    # sandbox = true;
  };
}
