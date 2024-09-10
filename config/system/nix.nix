ctx: {
  channel.enable = false;
  # optimise.automatic = true;
  settings = {
    # auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    log-lines = 48;
    # sandbox = true;
  };
}
