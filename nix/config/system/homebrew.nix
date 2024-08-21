ctx:
ctx.linux-mac null {
  casks = [
    "git-credential-manager"
    "minecraft"
    "steam"
    "tor-browser"
  ];
  enable = true;
  onActivation.autoUpdate = true;
}
