ctx:
(builtins.mapAttrs (_: s: s // { enable = true; }) ({
  emacs = {
    package = ctx.emacs;
    # exec = "emacs";
  };
} // (ctx.linux-mac {
  openssh = { };
  xserver = {
    desktopManager.pantheon.enable = true;
    displayManager.lightdm.enable = true;
    xkb.layout = "us";
    libinput.enable = true;
  };
} { nix-daemon = { }; })))
// ctx.linux-mac { pantheon.apps.enable = false; } { }
