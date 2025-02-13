ctx:
(builtins.mapAttrs (_: s: s // { enable = true; }) (
  {
    emacs = {
      package = ctx.emacs;
      # exec = "emacs";
    };
  }
  // (ctx.linux-mac {
    libinput = { };
    openssh = { };
    xserver = {
      desktopManager.pantheon.enable = true;
      displayManager.lightdm.enable = true;
      xkb.layout = "us";
    };
  } { })
))
// ctx.linux-mac { pantheon.apps.enable = false; } { }
