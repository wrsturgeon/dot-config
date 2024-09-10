ctx: {
  channel.enable = false;
  gc = {
    automatic = true;
    dates = [ "04:00" ];
    interval = {
      Hour = 4;
      Minute = 0;
    };
    options = "-d";
  };
  optimise = {
    automatic = true;
    dates = [ "04:01" ];
  };
  settings = {
    # auto-optimise-store = true; # <https://discourse.nixos.org/t/difference-between-nix-settings-auto-optimise-store-and-nix-optimise-automatic/25350>
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    log-lines = 48;
    # sandbox = true;
  };
}
