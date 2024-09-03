ctx:
builtins.mapAttrs (s: s // { enable = true; }) ({
  emacs = {
    package = ctx.emacs;
    # exec = "emacs";
  };
} // (ctx.linux-mac {
  openssh = { };
  pantheon.apps.enable = false;
  xserver = {
    desktopManager.pantheon.enable = true;
    displayManager.lightdm.enable = true;
    xkb.layout = "us";
    libinput.enable = true;
  };
} { nix-daemon = { }; }))
