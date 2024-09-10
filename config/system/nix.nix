ctx: {
  channel.enable = false;
  optimise = {
    automatic = true;
    dates = [ "04:01" ];
  }; # <https://discourse.nixos.org/t/difference-between-nix-settings-auto-optimise-store-and-nix-optimise-automatic/25350>
  gc = {
    automatic = true;
    dates = [ "04:00" ];
    interval = {
      Hour = 4;
      Minute = 0;
    };
    options = "-d";
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
