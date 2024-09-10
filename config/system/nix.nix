ctx: {
  channel.enable = false;
  optimise.automatic = true; # <https://discourse.nixos.org/t/difference-between-nix-settings-auto-optimise-store-and-nix-optimise-automatic/25350>
  gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
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
