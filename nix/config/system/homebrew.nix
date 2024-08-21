ctx:
ctx.linux-mac null {
  casks = [
    "arc"
    "git-credential-manager"
    "minecraft"
    "steam"
    "tor-browser"
  ];
  enable = true;
  onActivation.autoUpdate = true;
}
