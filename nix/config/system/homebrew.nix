ctx:
ctx.linux-mac null {
  # Effectively disallow Homebrew by immediately "zapping" everything installed out of existence:
  brews = [ ];
  casks = [
    "minecraft"
    "signal"
    "steam"
    "tor-browser"
    "wezterm"
  ];
  enable = true;
  masApps = { };
  onActivation = {
    autoUpdate = true;
    cleanup = "zap";
  };
  whalebrews = [ ];
}
