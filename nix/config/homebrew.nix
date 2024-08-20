ctx:
ctx.linux-mac null {
  casks = [
    "arc"
    "git-credential-manager"
    "logseq"
    "minecraft"
    "steam"
    "tor-browser"
  ];
  enable = true;
  onActivation = {
    autoUpdate = true;
    cleanup = "zap";
  };
}
