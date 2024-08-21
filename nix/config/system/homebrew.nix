ctx:
ctx.linux-mac null {
  casks = [
    "minecraft"
    "steam"
    "tor-browser"
  ];
  enable = true;
  onActivation.autoUpdate = true;
}
