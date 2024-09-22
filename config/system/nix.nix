ctx: {
  channel.enable = false;
  extraOptions = ''
    keep-outputs = false
    keep-derivations = false
  '';
  gc =
    {
      automatic = true;
      options = "--delete-older-than 1d";
    }
    // ctx.linux-mac { } {
      interval = {
        Hour = 3;
        Minute = 1;
      };
      user = "root";
    };
  optimise =
    {
      automatic = true;
    }
    // ctx.linux-mac { } {
      interval = {
        Hour = 4;
        Minute = 1;
      };
      user = "root";
    };
  settings = {
    # auto-optimise-store = true; # <https://discourse.nixos.org/t/difference-between-nix-settings-auto-optimise-store-and-nix-optimise-automatic/25350>
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    log-lines = 48;
    sandbox = ctx.linux-mac true false;
  };
}
