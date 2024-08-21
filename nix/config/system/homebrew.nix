ctx:
ctx.linux-mac null {
  # Effectively disallow Homebrew by immediately "zapping" everything installed out of existence:
  brews = [ ];
  casks = [ ];
  enable = true;
  onActivation.cleanup = "zap";
}
