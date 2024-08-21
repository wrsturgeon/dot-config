ctx:
ctx.linux-mac null {
  # Effectively disallow Homebrew by immediately "zapping" everything installed out of existence:
  brews = [ ];
  casks = [
    "minecraft"
    "steam"
  ];
  enable = true;
  masApps = [ ];
  onActivation = {
    autoUpdate = true;
    cleanup = "zap";
  };
  whalebrews = [ ];
}
